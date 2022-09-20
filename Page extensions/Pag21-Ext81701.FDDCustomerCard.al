pageextension 81701 "FDD Customer Card" extends "Customer Card" //21
{
    layout
    {
        addfirst(factboxes)
        {
            part(FDDDragAndDropFactbox; "FDD Drag & Drop Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(18), "No." = field("No.");
            }
        }
    }
}
