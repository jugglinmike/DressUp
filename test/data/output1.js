(function( window, $ ) {

  var $mark1 = $("<div>").attr("style", "font-family: 'Century Gothic', sans-serif;   height: 120%;");
  var $mark2 = $("<div>").attr("style", 'font-family: \'Century Gothic\', sans-serif;   height: 120%;');

  var $matt1 = $("<div>").attr("style", "background: url(\"bg.png\");   z-index: 2;");
  var $matt2 = $("<div>").attr("style", 'background: url("bg.png");   z-index: 2;');

  var $style1 = $("<style>").text("div.mark {   font-family: 'Century Gothic', sans-serif;   height: 120%; } div.matt {   background: url(\"bg.png\");   z-index: 2; } ");
  var $style2 = $("<style>").text('div.mark {   font-family: \'Century Gothic\', sans-serif;   height: 120%; } div.matt {   background: url("bg.png");   z-index: 2; } ');

  var $unknown1 = $("<div>").attr("style", "!import_rule div.k");
  var $unknown2 = $("<div>").attr("style", '!import_rule div.k');
  var $unknown3 = $("<style>").text("!import_file input1k.css");
  var $unknown4 = $("<style>").text('!import_file input1k.css');

})( this, this.jQuery );
