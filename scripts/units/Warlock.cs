using Godot;

public partial class Warlock : CombatUnit
{
    [Export] public float SpellDamage = 30f;
    [Export] public PackedScene MagicProjectileScene;

    public override void CastPrimaryAbilityOn(CombatUnit target)
    {
        if (AbilityCooldown > 0) return;
        if (target == null) return;
        if (IsFriendlyTo(target)) return;

        AbilityCooldown = AbilityCooldownTime;

        if (MagicProjectileScene != null)
        {
            var proj = MagicProjectileScene.Instantiate<MagicProjectile>();
            proj.GlobalPosition = GlobalPosition + Vector3.Up;
            proj.Target = target;
            proj.Damage = SpellDamage;
            proj.Tint = new Color(0.5f, 0.1f, 1f);
            proj.CasterFaction = Faction;
            proj.SplashRadius = 3.5f;
            GetTree().CurrentScene.AddChild(proj);
        }
    }
}
