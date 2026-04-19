using Godot;

public partial class Wizard : CombatUnit
{
    [Export] public float SpellDamage = 25f;
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
            proj.Tint = new Color(1f, 0.6f, 0.2f);
            proj.CasterFaction = Faction;
            GetTree().CurrentScene.AddChild(proj);
        }
    }
}
