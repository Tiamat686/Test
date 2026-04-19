using Godot;

public partial class Wizard : CombatUnit
{
    [Export] public float SpellDamage = 25f;

    public override void CastPrimaryAbilityOn(CombatUnit target)
    {
        if (target == null) return;
        if (!IsFriendlyTo(target))
        {
            target.TakeDamage(SpellDamage);
        }
    }
}
