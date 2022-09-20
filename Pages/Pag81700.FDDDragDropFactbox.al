page 81700 "FDD Drag & Drop Factbox"
{
    Caption = 'Content Drag & Drop';
    PageType = ListPart;
    UsageCategory = None;
    SourceTable = "Document Attachment";
    InsertAllowed = false;
    ModifyAllowed = false;
    RefreshOnActivate = true;
    layout
    {
        area(content)
        {
            usercontrol(FileDragAndDrop; "FDD File Drag and Drop")
            {
                ApplicationArea = All;

                trigger ControlAddinReady()
                begin
                    CurrPage.FileDragAndDrop.InitializeFileDragAndDrop();
                end;

                trigger OnFileUpload(FileName: Text; FileAsText: Text; IsLastFile: Boolean)
                var
                    Base64Convert: Codeunit "Base64 Convert";
                    TempBlob: Codeunit "Temp Blob";
                    FileInStream: InStream;
                    FileOutStream: OutStream;
                begin
                    TempBlob.CreateOutStream(FileOutStream, TextEncoding::UTF8);
                    Base64Convert.FromBase64(FileAsText.Substring(FileAsText.IndexOf(',') + 1), FileOutStream);
                    TempBlob.CreateInStream(FileInStream, TextEncoding::UTF8);

                    Rec.ID := 0;
                    Rec.SaveAttachmentFromStream(FileInStream, GetSourceRecRef(), FileName);

                    if IsLastFile then
                        CurrPage.Update(false);
                end;
            }
            repeater(Rep)
            {
                ShowCaption = false;
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the File Name field.';
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the File Extensions field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(DownloadFile)
            {
                ApplicationArea = All;
                Caption = 'Download File';
                ToolTip = 'Download File';
                Image = Download;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Enabled = Rec."File Name" <> '';
                trigger OnAction()
                begin
                    FDDExport(true);
                end;
            }
        }
    }

    local procedure GetSourceRecRef(): RecordRef
    var
        RecRef: RecordRef;
        FieldRefNo: FieldRef;
        TableNo: Integer;
        TablePK: Text;
    begin
        Rec.FilterGroup(4);
        Evaluate(TableNo, Rec.GetFilter("Table ID"));
        Evaluate(TablePK, Rec.GetFilter("No."));
        RecRef.Open(TableNo);
        FieldRefNo := RecRef.Field(1);
        FieldRefNo.SetRange(TablePK);
        RecRef.FindFirst();
        Rec.FilterGroup(0);
        exit(RecRef);
    end;

    procedure FDDExport(ShowFileDialog: Boolean): Text
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        DocumentStream: OutStream;
        FullFileName: Text;
    begin
        if Rec.ID = 0 then
            exit;

        if not Rec."Document Reference ID".HasValue then
            exit;

        FullFileName := Rec."File Name" + '.' + Rec."File Extension";
        TempBlob.CreateOutStream(DocumentStream);
        Rec."Document Reference ID".ExportStream(DocumentStream);
        exit(FileManagement.BLOBExport(TempBlob, FullFileName, ShowFileDialog));
    end;
}
