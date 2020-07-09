dragElement(document.getElementById("die1-div"));
dragElement(document.getElementById("die2-div"));
dragElement(document.getElementById("die3-div"));
dragElement(document.getElementById("die4-div"));
dragElement(document.getElementById("die5-div"));


function dragElement(elmnt) {
  var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
  if (document.getElementById(elmnt.id + "header")) {
    // if present, the header is where you move the DIV from:
      document.getElementById(elmnt.id + "header").onmousedown = dragMouseDown;
      //document.getElementById(elmnt.id + "header").ontouchstart = dragMouseDown;
  } else {
    // otherwise, move the DIV from anywhere inside the DIV:
      elmnt.onmousedown = dragMouseDown;
      //elmnt.ontouchstart = dragMouseDown;
  }
  
  function dragMouseDown(e) {
    e = e || window.event;
    e.preventDefault();
    // get the mouse cursor position at startup:
      pos3 = e.clientX;
      pos4 = e.clientY;
      document.onmouseup = closeDragElement;
      //document.ontouchend = closeDragElement;
      // call a function whenever the cursor moves:
        document.onmousemove = elementDrag;
        //document.ontouchmove = elementDrag;
  }
  
  function elementDrag(e) {
    e = e || window.event;
    e.preventDefault();
    // calculate the new cursor position:
      pos1 = pos3 - e.clientX;
      pos2 = pos4 - e.clientY;
      pos3 = e.clientX;
      pos4 = e.clientY;
      // set the element's new position:
    elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
    elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
  }

  function closeDragElement() {
    // stop moving when mouse button is released:
    document.onmouseup = null;
    document.onmousemove = null;
    //document.ontouchend = null;
    //document.ontouchmove = null;
  }
}

dragElement(document.getElementById("die1-div"));
