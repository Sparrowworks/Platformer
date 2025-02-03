using Godot;
using Godot.Collections;

public partial class Help : Control
{
    private Label TitleLabel;
    private Label HelpLabel;

    private Tween PageSwitchTween;
    private int Page = 0;
    private bool IsChangingPage = false;

    private Array<string> HelpTitle = new()
    {
        "In-Game Controls:",
        "In-Game Credits :"
    };

    private Array<string> HelpText = new()
    {
        "use wasd or arrow keys to walk\npress space to jump\npress q in game to go back to menu\npress r to quickly restart the level\npress enter to proceed to the next level",
        "coding: Sp4r0w & VargaDot\ntesting: VargaDot\nart & Blocks font: kenney\nWatermelon Days font: Khurasan\nButton sprites: Viktor Gogela\nMusic: joshuuu (alt OST: Clustertruck OST)"
    };

    public override void _Ready()
    {
        TitleLabel = GetNode<Label>("Title");
        HelpLabel = GetNode<Label>("Help");
    }

    private void SwitchPage()
    {
        if (IsChangingPage)
            return;

        IsChangingPage = true;

        PageSwitchTween = GetTree().CreateTween();
        PageSwitchTween.SetTrans(Tween.TransitionType.Elastic);
        PageSwitchTween.SetEase(Tween.EaseType.InOut);

        PageSwitchTween.TweenProperty(HelpLabel, "position:x", 4000, 1);
        PageSwitchTween.TweenCallback(Callable.From(
            () => {
                Page++;
                if (Page > 1)
                    Page = 0;

                TitleLabel.Text = HelpTitle[Page];
                HelpLabel.Text = HelpText[Page];
                HelpLabel.Position = new Vector2(-4000, HelpLabel.Position.Y);
            }
        ));
        PageSwitchTween.TweenProperty(HelpLabel, "position:x", 485.5, 1);
        PageSwitchTween.TweenCallback(Callable.From(
            () => {
                IsChangingPage = false;
                PageSwitchTween.Kill();
            }
        ));
    }

    private void OnBackPressed()
    {
        if (IsChangingPage)
            return;

        Global.Composer.Call("load_scene", "res://src/MainMenu/MainMenu.tscn");
    }
}
