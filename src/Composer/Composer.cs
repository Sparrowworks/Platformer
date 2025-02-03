using Godot;
using System;
using System.Diagnostics.Tracing;

public partial class Composer : Node
{
    [Signal]
    public delegate void FinishedInitializingEventHandler();

    [Signal]
    public delegate void InvalidSceneEventHandler(string path);

    [Signal]
    public delegate void FailedLoadingEventHandler(string path);

    [Signal]
    public delegate void UpdatedLoadingEventHandler(string path, int progress);

    [Signal]
    public delegate void FinishedLoadingEventHandler(Node scene);

    [Signal]
    public delegate void LoadingActivatedEventHandler();

    private bool _hasInitialized = false;
    public bool HasInitialized {
        get => _hasInitialized;
        private set
        {
            _hasInitialized = value;
            if (_hasInitialized)
                EmitSignal(SignalName.FinishedInitializing);
        }
    }
}

