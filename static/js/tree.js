////////////////////////////////////////////////////////////////////////////////////////////////////////
///				OBJET ARBRE
////////////////////////////////////////////////////////////////////////////////////////////////////////

var Arbre = function(id, target, display_settings) {
  this.questions_val_min;
  this.questions_val_max;
  this.questions_val_mean;
  this.questions_proba_haut;
  this.div_target = target;
  this.identifiant = id;
  this.displayed = false;
	this.type = display_settings;
  if (this.type == "trees") {
    this.html =
      '<div class="proba_tree" id=\"tree_' + this.identifiant + '\">\
					<span class="questions_val_mean"></span>\
	        <img src="' + tree_image + '" class="center img_tree"></img>\
					<div class="questions_right">\
						<span class="questions_proba_haut"></span>\
						<span class="questions_val_max"></span>\
						<span class="questions_proba_bas"></span>\
						<span class="questions_val_min"></span>\
					</div>\
	        	</div>';
  } else {
    this.html = '<div class="proba_tree" id=\"tree_' + this.identifiant + '\"></div>';
  }
};

Arbre.prototype.display = function() {
  if (!this.displayed && this.div_target) {
    // we append the html
    $(this.div_target).append(this.html);
    this.displayed = true;
  }
};

Arbre.prototype.remove = function() {
  if (this.displayed) {
    $('#tree_' + this.identifiant).remove();
    this.displayed = false;
  }
};

Arbre.prototype.update = function() {
  if (this.type == "trees") {
    $('#tree_' + this.identifiant + ' .questions_val_min').empty();
    $('#tree_' + this.identifiant + ' .questions_val_min').append(this.questions_val_min);
    $('#tree_' + this.identifiant + ' .questions_val_max').empty();
    $('#tree_' + this.identifiant + ' .questions_val_max').append(this.questions_val_max);
    $('#tree_' + this.identifiant + ' .questions_val_mean').empty();
    $('#tree_' + this.identifiant + ' .questions_val_mean').append(this.questions_val_mean);
    $('#tree_' + this.identifiant + ' .questions_proba_haut').empty();
    $('#tree_' + this.identifiant + ' .questions_proba_haut').append(this.questions_proba_haut);
    $('#tree_' + this.identifiant + ' .questions_proba_bas').empty();
    $('#tree_' + this.identifiant + ' .questions_proba_bas').append((1 - this.questions_proba_haut).toFixed(2));
  } else {
		var _this = this
    var ajaxdata = {
      "type": "pie_chart",
      "names": [this.questions_val_min, this.questions_val_max],
      "probas": [this.questions_proba_haut, (1 - this.questions_proba_haut).toFixed(2)]
    };
    $.post('ajax', JSON.stringify(ajaxdata), function(data) {
			console.log('#tree_' + _this.identifiant);
			$('#tree_' + _this.identifiant).empty();
			$('#tree_' + _this.identifiant).append(data);
    });
  }

};
