function InitializeControl(controlId) {

}

function InitializeFileDragAndDrop() {
    nodes = window.parent.document.querySelectorAll('div[controlname="FDD Drag & Drop Factbox"]'); //find all controls by page name
    FactBox = nodes[nodes.length - 1]; //get last control
    
    // Prevent default drag behaviors
    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
        FactBox.addEventListener(eventName, preventDefaults, false)
        document.body.addEventListener(eventName, preventDefaults, false)
    });
  
    // Highlight drop area when item is dragged over it
    ['dragenter', 'dragover'].forEach(eventName => {
        FactBox.addEventListener(eventName, highlight, false)
    });
  
    //Unhiglight
    ['dragleave', 'drop'].forEach(eventName => {
        FactBox.addEventListener(eventName, unhighlight, false)
    });
    
    // Handle dropped files
    FactBox.addEventListener('drop', handleDrop, false)

}

function preventDefaults (e) {
    e.preventDefault()
    e.stopPropagation()
}

function highlight(e) {
    FactBox.style.border = "thick dotted blue";
}

function unhighlight(e) {
    FactBox.style.border = "";
}

function handleDrop(e) {
    var dt = e.dataTransfer
    var files = dt.files

    handleFiles(files)
}

var filesCount = 0;

function handleFiles(files) {
    files = [...files]
    filesCount = files.length
    files.forEach(uploadFile)
}

function uploadFile(file, i) {
    var reader = new FileReader();
    reader.addEventListener("loadend", function() {
        // reader.result contains the contents of blob
        var base64data = reader.result;
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('OnFileUpload',[file.name,base64data,filesCount == (i + 1)]);
     });
     reader.readAsDataURL(file);
}