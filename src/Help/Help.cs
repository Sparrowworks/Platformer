using Godot;
using Godot.Collections;
using System;

public partial class Help : Control
{

    private Composer Composer;
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
        "coded by Sp4r0w\nart & Blocks font made by kenney\nWatermelon Days font made by Khurasan\nButton sprites made by Viktor Gogela\nMusic by joshuuu (alt OST: Clustertruck OST)"
    };

    public override void _Ready()
    {
        Composer = GetNode<Composer>("/root/Composer");
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

        Composer.LoadScene("res://src/MainMenu/MainMenu.tscn");
    }
}
