(function( window, $ ) {

  var $mark1 = $("<div>").attr("style", "!import_rule div.mark");
  var $mark2 = $("<div>").attr("style", '!import_rule div.mark');

  var $matt1 = $("<div>").attr("style", "!import_rule div.matt");
  var $matt2 = $("<div>").attr("style", '!import_rule div.matt');

  var $style1 = $("<style>").text("!import_file input1.css");
  var $style2 = $("<style>").text('!import_file input1.css');

  var $unknown1 = $("<div>").attr("style", "!import_rule div.k");
  var $unknown2 = $("<div>").attr("style", '!import_rule div.k');
  var $unknown3 = $("<style>").text("!import_file input1k.css");
  var $unknown4 = $("<style>").text('!import_file input1k.css');

})( this, this.jQuery );
