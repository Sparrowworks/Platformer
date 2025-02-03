using Godot;
using System;

public partial class MainMenu : Control
{
    private Composer Composer;

    public override void _Ready()
    {
        Composer = GetNode<Composer>("/root/Composer");
    }

    private void OnPlayPressed()
    {

    }

    private void OnSettingsPressed()
    {

    }

    private void OnHelpPressed()
    {
        Composer.LoadScene("res://src/Help/Help.tscn");
    }

    private void OnQuitPressed()
    {
        GetTree().Quit();
    }
}
