using Godot;

public partial class Warlock : CombatUnit
{
    [Export] public float SpellDamage = 30f;

    public override void CastPrimaryAbilityOn(CombatUnit target)
    {
        if (target == null) return;
        if (!IsFriendlyTo(target))
        {
            target.TakeDamage(SpellDamage);
        }
    }
}
