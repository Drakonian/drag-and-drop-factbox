controladdin "FDD File Drag and Drop"
{
    Scripts = 'https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.3.1.min.js',
        'DragAndDropAddin/script.js';
    StartupScript = 'DragAndDropAddin/Startup.js';

    RequestedHeight = 1;
    MinimumHeight = 1;
    HorizontalStretch = true;

    event ControlAddinReady();
    event OnFileUpload(FileName: Text; FileAsText: Text; IsLastFile: Boolean)
    procedure InitializeFileDragAndDrop()
}