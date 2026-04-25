const canvas = document.getElementById('game');
const ctx = canvas.getContext('2d');

const ui = {
  gold: document.getElementById('gold'),
  soldiers: document.getElementById('soldiers'),
  wave: document.getElementById('wave'),
  baseHp: document.getElementById('baseHp'),
  log: document.getElementById('log'),
  trainBtn: document.getElementById('trainBtn'),
  fortBtn: document.getElementById('fortBtn'),
  startBtn: document.getElementById('startBtn'),
  resetBtn: document.getElementById('resetBtn')
};

const TILE = 32;
const BASE_POS = { x: 92, y: 286, w: 70, h: 76 };

let game;

function resetGame() {
  game = {
    running: false,
    gold: 110,
    baseHp: 100,
    wave: 0,
    enemies: [],
    units: [],
    selectedUnitId: null,
    spawnTimer: 0,
    waveCount: 0,
    messageTTL: 0,
    message: ''
  };
  addLog('Вождь: "Командир, крепость уязвима. Готовь оборону!"');
  syncHud();
}

function addLog(text) {
  const line = document.createElement('div');
  line.textContent = `• ${text}`;
  ui.log.prepend(line);
  while (ui.log.children.length > 7) ui.log.removeChild(ui.log.lastChild);
}

function syncHud() {
  ui.gold.textContent = Math.floor(game.gold);
  ui.soldiers.textContent = game.units.filter((u) => u.alive).length;
  ui.wave.textContent = game.wave;
  ui.baseHp.textContent = Math.max(0, game.baseHp);
}

function trainUnit() {
  if (game.gold < 30) return showToast('Недостаточно золота.');
  game.gold -= 30;
  const id = Math.random().toString(16).slice(2);
  game.units.push({
    id,
    x: 165 + Math.random() * 16,
    y: 290 + Math.random() * 34,
    hp: 30,
    attack: 8,
    cooldown: 0,
    targetX: 250,
    targetY: 280,
    alive: true
  });
  addLog('Тренирован новый пехотинец.');
  syncHud();
}

function fortifyBase() {
  if (game.gold < 50) return showToast('Нужно 50 золота на укрепление.');
  game.gold -= 50;
  game.baseHp = Math.min(180, game.baseHp + 25);
  addLog('Крепость укреплена (+25 прочности).');
  syncHud();
}

function startWave() {
  if (game.running) return;
  game.running = true;
  game.wave += 1;
  game.waveCount = 5 + game.wave * 2;
  game.spawnTimer = 45;
  addLog(`Началась волна #${game.wave}.`);
  syncHud();
}

function spawnEnemy() {
  const laneY = 120 + Math.random() * 330;
  game.enemies.push({
    x: canvas.width + 20,
    y: laneY,
    hp: 22 + game.wave * 4,
    speed: 0.45 + game.wave * 0.06,
    dmg: 8 + game.wave,
    cooldown: 0
  });
}

function showToast(text) {
  game.message = text;
  game.messageTTL = 120;
}

function update() {
  if (game.running && game.waveCount > 0) {
    game.spawnTimer -= 1;
    if (game.spawnTimer <= 0) {
      spawnEnemy();
      game.waveCount -= 1;
      game.spawnTimer = Math.max(12, 42 - game.wave * 2);
    }
  }

  for (const unit of game.units) {
    if (!unit.alive) continue;
    const dx = unit.targetX - unit.x;
    const dy = unit.targetY - unit.y;
    const dist = Math.hypot(dx, dy);
    if (dist > 2) {
      unit.x += (dx / dist) * 1.1;
      unit.y += (dy / dist) * 1.1;
    }

    unit.cooldown = Math.max(0, unit.cooldown - 1);
    const enemy = game.enemies.find((e) => Math.hypot(e.x - unit.x, e.y - unit.y) < 42);
    if (enemy && unit.cooldown === 0) {
      enemy.hp -= unit.attack;
      unit.cooldown = 30;
    }
  }

  for (const enemy of game.enemies) {
    enemy.cooldown = Math.max(0, enemy.cooldown - 1);
    const nearUnit = game.units.find((u) => u.alive && Math.hypot(u.x - enemy.x, u.y - enemy.y) < 34);

    if (nearUnit) {
      if (enemy.cooldown === 0) {
        nearUnit.hp -= enemy.dmg;
        enemy.cooldown = 42;
        if (nearUnit.hp <= 0) nearUnit.alive = false;
      }
    } else {
      enemy.x -= enemy.speed;
    }

    const touchingBase = enemy.x < BASE_POS.x + BASE_POS.w && enemy.y > BASE_POS.y - 20 && enemy.y < BASE_POS.y + BASE_POS.h + 20;
    if (touchingBase && enemy.cooldown === 0) {
      game.baseHp -= enemy.dmg;
      enemy.cooldown = 40;
      if (game.baseHp <= 0) {
        game.baseHp = 0;
        addLog('Крепость пала. Игра окончена.');
        game.running = false;
      }
    }
  }

  const before = game.enemies.length;
  game.enemies = game.enemies.filter((e) => e.hp > 0 && e.x > -40);
  if (before > game.enemies.length) {
    const killed = before - game.enemies.length;
    game.gold += killed * 12;
  }

  if (game.running && game.waveCount === 0 && game.enemies.length === 0) {
    game.running = false;
    game.gold += 25 + game.wave * 4;
    addLog(`Волна ${game.wave} отражена. Награда получена.`);
  }

  if (game.messageTTL > 0) game.messageTTL -= 1;
  syncHud();
}

function drawGrid() {
  ctx.fillStyle = '#2d4a26';
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  for (let x = 0; x < canvas.width; x += TILE) {
    for (let y = 0; y < canvas.height; y += TILE) {
      const shade = ((x + y) / TILE) % 2 === 0 ? '#35592d' : '#2f4d29';
      ctx.fillStyle = shade;
      ctx.fillRect(x, y, TILE, TILE);
    }
  }

  ctx.fillStyle = '#8c6b3e';
  ctx.fillRect(0, 250, canvas.width, 80);
}

function drawBase() {
  ctx.fillStyle = '#56402a';
  ctx.fillRect(BASE_POS.x, BASE_POS.y, BASE_POS.w, BASE_POS.h);
  ctx.fillStyle = '#8b6a44';
  ctx.fillRect(BASE_POS.x + 10, BASE_POS.y - 16, BASE_POS.w - 20, 16);

  const hpW = 70;
  ctx.fillStyle = '#00000088';
  ctx.fillRect(BASE_POS.x, BASE_POS.y - 24, hpW, 9);
  ctx.fillStyle = game.baseHp > 40 ? '#5ec04e' : '#d9534f';
  ctx.fillRect(BASE_POS.x, BASE_POS.y - 24, (game.baseHp / 180) * hpW, 9);
}

function drawUnits() {
  for (const unit of game.units) {
    if (!unit.alive) continue;
    ctx.fillStyle = unit.id === game.selectedUnitId ? '#79d3ff' : '#3cb2f0';
    ctx.fillRect(unit.x - 8, unit.y - 8, 16, 16);
    ctx.fillStyle = '#102533';
    ctx.fillRect(unit.x - 5, unit.y - 5, 10, 10);
  }
}

function drawEnemies() {
  for (const enemy of game.enemies) {
    ctx.fillStyle = '#b64537';
    ctx.fillRect(enemy.x - 9, enemy.y - 9, 18, 18);
    ctx.fillStyle = '#5a1b14';
    ctx.fillRect(enemy.x - 4, enemy.y - 4, 8, 8);
  }
}

function drawOverlay() {
  ctx.fillStyle = '#ffe5b7';
  ctx.font = '16px Verdana';
  ctx.fillText('Орочья крепость', BASE_POS.x - 20, BASE_POS.y + 96);

  if (!game.running && game.baseHp > 0) {
    ctx.fillStyle = '#00000090';
    ctx.fillRect(300, 16, 440, 34);
    ctx.fillStyle = '#f3d7aa';
    ctx.fillText('Подготовь войска и нажми "Начать бой"', 336, 38);
  }

  if (game.baseHp <= 0) {
    ctx.fillStyle = '#000000bb';
    ctx.fillRect(220, 220, 580, 120);
    ctx.fillStyle = '#ffb0a8';
    ctx.font = 'bold 38px Verdana';
    ctx.fillText('ПОРАЖЕНИЕ', 390, 290);
  }

  if (game.messageTTL > 0) {
    ctx.fillStyle = '#000000aa';
    ctx.fillRect(14, 14, 290, 30);
    ctx.fillStyle = '#f6d9a8';
    ctx.font = '14px Verdana';
    ctx.fillText(game.message, 20, 34);
  }
}

function render() {
  drawGrid();
  drawBase();
  drawUnits();
  drawEnemies();
  drawOverlay();
}

function loop() {
  update();
  render();
  requestAnimationFrame(loop);
}

canvas.addEventListener('click', (e) => {
  if (game.baseHp <= 0) return;
  const rect = canvas.getBoundingClientRect();
  const x = ((e.clientX - rect.left) / rect.width) * canvas.width;
  const y = ((e.clientY - rect.top) / rect.height) * canvas.height;

  const picked = game.units.find((u) => u.alive && Math.hypot(u.x - x, u.y - y) < 14);
  if (picked) {
    game.selectedUnitId = picked.id;
    return;
  }

  const selected = game.units.find((u) => u.id === game.selectedUnitId && u.alive);
  if (selected) {
    selected.targetX = x;
    selected.targetY = y;
  }
});

ui.trainBtn.addEventListener('click', trainUnit);
ui.fortBtn.addEventListener('click', fortifyBase);
ui.startBtn.addEventListener('click', startWave);
ui.resetBtn.addEventListener('click', resetGame);

resetGame();
for (let i = 0; i < 2; i++) trainUnit();
loop();
