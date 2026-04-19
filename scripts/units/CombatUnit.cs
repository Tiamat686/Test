using Godot;

public partial class CombatUnit : CharacterBody3D
{
    [Export] public string UnitName = "Unit";
    [Export] public string Faction = "Neutral";
    [Export] public float MaxHp = 100f;
    [Export] public float Damage = 10f;
    [Export] public float Armor = 0f;
    [Export] public float Speed = 3.0f;
    [Export] public float AttackRange = 1.5f;
    [Export] public float AttackInterval = 1.0f;

    [Export] public float AbilityCooldownTime = 5f;
    protected float AbilityCooldown = 0f;

    protected float CurrentHp;
    protected Vector3 TargetPosition;
    protected bool Moving = false;
    protected CombatUnit AttackTargetUnit = null;
    protected float AttackCooldown = 0f;
    protected bool IsDead = false;

    public override void _Ready()
    {
        CurrentHp = MaxHp;
    }

    public virtual float GetCurrentHp() => CurrentHp;
    public virtual bool IsFriendlyTo(CombatUnit other) => other != null && other.Faction == Faction;

    public virtual void MoveTo(Vector3 pos)
    {
        TargetPosition = pos;
        Moving = true;
        AttackTargetUnit = null;
    }

    public virtual void AttackTarget(CombatUnit target)
    {
        if (target == null || target == this) return;
        AttackTargetUnit = target;
        Moving = true;
    }

    public virtual void TakeDamage(float rawDamage)
    {
        if (IsDead) return;
        float finalDamage = Mathf.Max(1f, rawDamage - Armor);
        CurrentHp -= finalDamage;
        if (CurrentHp <= 0)
        {
            Die();
        }
    }

    public virtual void ReceiveHeal(float amount)
    {
        if (IsDead) return;
        CurrentHp = Mathf.Min(MaxHp, CurrentHp + amount);
    }

    public virtual void Die()
    {
        IsDead = true;
        QueueFree();
    }

    public virtual void OnSelectionChanged(bool selected)
    {
        var sprite = GetNodeOrNull<Sprite3D>("Sprite3D");
        if (sprite != null)
            sprite.Modulate = selected ? new Color(0, 1, 0) : new Color(1, 1, 1);
    }

    public override void _PhysicsProcess(double delta)
    {
        if (IsDead) return;

        if (AttackCooldown > 0)
            AttackCooldown -= (float)delta;

        if (AbilityCooldown > 0)
            AbilityCooldown -= (float)delta;

        if (AttackTargetUnit != null)
        {
            if (!GodotObject.IsInstanceValid(AttackTargetUnit))
            {
                AttackTargetUnit = null;
                return;
            }

            float dist = GlobalPosition.DistanceTo(AttackTargetUnit.GlobalPosition);
            if (dist <= AttackRange)
            {
                Velocity = Vector3.Zero;
                MoveAndSlide();
                Moving = false;
                if (AttackCooldown <= 0)
                {
                    AttackTargetUnit.TakeDamage(Damage);
                    AttackCooldown = AttackInterval;
                }
                return;
            }
            else
            {
                TargetPosition = AttackTargetUnit.GlobalPosition;
                Moving = true;
            }
        }

        if (Moving)
        {
            Vector3 direction = TargetPosition - GlobalPosition;
            direction.Y = 0;
            if (direction.Length() > 0.2f)
            {
                Velocity = direction.Normalized() * Speed;
                MoveAndSlide();
            }
            else
            {
                Velocity = Vector3.Zero;
                MoveAndSlide();
                Moving = false;
            }
        }
    }

    public virtual void CastPrimaryAbilityOn(CombatUnit target)
    {
        if (AbilityCooldown > 0) return;
        AbilityCooldown = AbilityCooldownTime;
        GD.Print($"{UnitName} ability placeholder on target");
    }
}
