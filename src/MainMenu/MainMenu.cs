using Godot;

public partial class MainMenu : Control
{
    public override void _Ready()
    {
        
    }

    private void OnPlayPressed()
    {

    }

    private void OnSettingsPressed()
    {

    }

    private void OnHelpPressed()
    {
        Global.Composer.Call("load_scene", "res://src/Help/Help.tscn");
    }

    private void OnQuitPressed()
    {
        GetTree().Quit();
    }
}
