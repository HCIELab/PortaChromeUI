function calculateDaysBetweenDates(begin, end) {
  var beginDate = new Date(begin);
  var endDate = new Date(end);
  var millisecondsPerDay = 1000 * 60 * 60 * 24;
  return Math.floor((endDate - beginDate) / millisecondsPerDay);

}

// find all images without alternate text
// and give them a red border
function process() {
  var images = document.getElementsByTagName('img');
  for (var i = 0; i < images.length; i++) {
    if (images[i].alt == '') {
      images[i].style.border = '3px solid red';
    }
  }
}


// find image with name
function findImage(name) {
  var images = document.getElementsByTagName('img');
  for (var i = 0; i < images.length; i++) {
    if (images[i].alt == name) {
      return images[i];
    }
  }
}