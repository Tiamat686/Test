using Godot;

public partial class Cleric : CombatUnit
{
    [Export] public float HealAmount = 15f;

    public override void CastPrimaryAbilityOn(CombatUnit target)
    {
        if (target == null) return;
        if (IsFriendlyTo(target))
        {
            target.ReceiveHeal(HealAmount);
        }
    }
}
