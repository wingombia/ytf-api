var text = "";
var size = 16;

function updateText(newText) {
  text = newText;
  updateImage();
}

function updateSize(newSize) {
  size = newSize;
  updateImage();
}

function arrayBufferToBase64(buffer) {
  var binary = "";
  var bytes = [].slice.call(new Uint8Array(buffer));

  bytes.forEach(b => (binary += String.fromCharCode(b)));

  return window.btoa(binary);
}

function updateImage() {
  let url = `http://localhost:3000/api/get?font=Purisa&text=${text}&size=${size}`;
  fetch(url).then(function(res) {
    if (!res.ok) {
      return;
    }
    res.arrayBuffer().then(buffer => {
      var base64Flag = "data:image/jpeg;base64,";
      var imageStr = arrayBufferToBase64(buffer);

      document.querySelector("img").src = base64Flag + imageStr;
    });
  });
}

updateImage();

