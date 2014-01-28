function mapOverlay(bounds, image, map) {
  this.bounds_ = bounds;
  this.image_ = image;
  this.map_ = map;
  this.div_ = null;

  this.setMap(map);
}

mapOverlay.prototype = new google.maps.OverlayView(); 

mapOverlay.prototype.onAdd = function() {

  var div = document.createElement('DIV');
  div.style.borderStyle = "none";
  div.style.borderWidth = "0px";
  div.style.position = "absolute";

  var img = document.createElement("img");
  img.src = this.image_;

  div.appendChild(img);

  this.div_ = div;

  var panes = this.getPanes();
  panes.overlayImage.appendChild(div);    

};

mapOverlay.prototype.draw = function() {

  // Size and position the overlay. We use a southwest and northeast
  // position of the overlay to peg it to the correct position and size.
  // We need to retrieve the projection from this overlay to do this.
  var overlayProjection = this.getProjection();

  // Retrieve the southwest and northeast coordinates of this overlay
  // in latlngs and convert them to pixels coordinates.
  // We'll use these coordinates to resize the DIV.
  var sw = overlayProjection.fromLatLngToDivPixel(this.bounds_.getSouthWest());
  var ne = overlayProjection.fromLatLngToDivPixel(this.bounds_.getNorthEast());

  // Resize the image's DIV to fit the indicated dimensions.
  var div = this.div_;
  div.style.left = sw.x + 'px';
  div.style.top = ne.y + 'px';
  div.style.width = (ne.x - sw.x) + 'px';
  div.style.height = (sw.y - ne.y) + 'px';

};

mapOverlay.prototype.onRemove = function() {
  this.div_.parentNode.removeChild(this.div_);
  this.div_ = null;
};