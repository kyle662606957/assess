%include('header_init.tpl', heading='Manage your attributes')

<br />
<br />
<h2 style="display:inline-block; margin-right: 40px;"> Delete current assessments: </h2>
<button type="button" class="btn btn-default del_simu">Delete</button>
<h2> List of current attributes: </h2>
<table class="table">
  <thead>
    <tr>
    <th style='width:50px;'>State</th>
    <th>Attribute name</th>
    <th>Unit</th>
    <th>Values</th>
    <th>Method</th> 
	<th>Mode</th>
    <th><img src='/static/img/delete.ico' style='width:16px;' class="del_simu"/></th>
    </tr>
  </thead>
  <tbody id="table_attributes">
  </tbody>
</table>
<br />
<br />
<div id="add_attribute">
    <h2> Add a new attribute: </h2>

    <div class="form-group">
        <label for="att_name">Name:</label>
        <input type="text" class="form-control" id="att_name" placeholder="Name">
    </div>

    <div class="form-group">
        <label for="att_unit">Unit:</label>
        <input type="text" class="form-control" id="att_unit" placeholder="Unit">
    </div>
    <div class="form-group">
        <label for="att_value_min">Min value:</label>
        <input type="text"  class="form-control" id="att_value_min" placeholder="Value">
    </div>
    <div class="form-group">
        <label for="att_value_max">Max value:</label>
        <input type="text"  class="form-control" id="att_value_max" placeholder="Value">
    </div>
    <div class="form-group">
        <label for="att_method">Method:</label>
        <select class="form-control">
          <option>Probability Equivalence</option>
          <option>Lottery Equivalence</option>
          <option>Certainty Equivalence - Constant Probability</option>
		  <option>Certainty Equivalence - Variable Probability</option>
        </select>
    </div>
    <div class="checkbox">
        <label>
		</select>
          <input name="mode" type="checkbox" id="att_mode" placeholder="Mode"> The min value is preferred (decreasing utility function)
        </label>
    </div>

    <button type="submit" class="btn btn-default" id="submit">Submit</button>
</div>


%include('header_end.tpl')

%include('js.tpl')
<script>
    $(function() {

       $('.del_simu').click(function() {
            if(confirm("Are you sure ?") == false){return};
            localStorage.clear();
            window.location.reload();
        });


        $('li.manage').addClass("active");
        var asses_session = JSON.parse(localStorage.getItem("asses_session"));

        
        if (!asses_session){
            asses_session = {"attributes": [], "k_calculus": [{"method":"multiplicative", "active":"false", "k":[], "GK":null, "GU":null},{"method":"multilinear","active":"false", "k":[], "GK":null, "GU":null}]};
            localStorage.setItem("asses_session", JSON.stringify(asses_session));
        }

        function sync_table() { 
			$('#table_attributes').empty();
            if (asses_session){
                for (var i=0; i < asses_session.attributes.length; i++) {
                    var attribute = asses_session.attributes[i];
					var text_table="<tr>";
					if(attribute.checked)
						text_table+='<td><input type="checkbox" id="checkbox_'+i+'" value="'+i+'" name="' + attribute.name + '" checked></td>';
					else
						text_table+='<td><input type="checkbox" id="checkbox_'+i+'" value="'+i+'" name="' + attribute.name + '" ></td>';
			
				
			
                    text_table += '<td>'+ attribute.name +'</td><td>'+ attribute.unit +'</td><td>['+ attribute.val_min +','+ attribute.val_max +']</td><td>'+ attribute.method +'</td><td>'+ attribute.mode +'</td>';
					text_table+='<td><img id="deleteK'+i+'" src="/static/img/delete.ico" style="width:16px;"/></td></tr>';
					
					$('#table_attributes').append(text_table);
					
					//we will define the action when we click on the check input
					$('#checkbox_'+i).click(function(){checked_button_clicked($(this))});
			
					(function(_i){
					$('#deleteK'+_i).click(function(){
					    if(confirm("Are you sure ?") == false){return};
						asses_session.attributes.splice(_i,1); 
						// backup local
						localStorage.setItem("asses_session", JSON.stringify(asses_session));
						//refresh the page
						window.location.reload();
						});
					})(i);
                }

            }
        }
        sync_table();

        var name = $('#att_name').val();

        $('#submit').click(function() {
            var name = $('#att_name').val();
            var unit = $('#att_unit').val();
            var val_min = parseInt($('#att_value_min').val());
            var val_max = parseInt($('#att_value_max').val());
                           
            var method="PE";
            if($( "select option:selected" ).text()=="Probability Equivalence")
            {
                method="PE";
            }
            else if($( "select option:selected" ).text()=="Lottery Equivalence")
            {
                method="LE";
            }
            else if($( "select option:selected" ).text()=="Certainty Equivalence - Constant Probability")
            {
                method="CE_Constant_Prob";
            }
			else if($( "select option:selected" ).text()=="Certainty Equivalence - Variable Probability")
            {
                method="CE_Variable_Prob";
            }
			
            if( $('input[name=mode]').is(':checked') ) {
                var mode = "reversed";	
            }
            else {
                var mode = "normal";
            }

            if (!(name || unit || val_min || val_max) || isNaN(val_min) || isNaN(val_max)) {
                alert('Please fill correctly all the fields');
            }
            else {
                asses_session.attributes.push({"name": name, 'unit': unit, 'val_min': val_min, 'val_max': val_max, 'method': method, 'mode' : mode ,'completed': 'False', 'checked':true, 'questionnaire': {'number': 0, 'points': [], 'utility': {}}});
                sync_table();
                localStorage.setItem("asses_session", JSON.stringify(asses_session));
            }
			
			
        });

        function isAttribute(name){
            for (var i=0; i < asses_session.attributes.length; i ++) {
                if (asses_session.attributes[i].name == name) {
                    return [true, i];
                }
            }
            return [false, 0];
        }
		
		
		function checked_button_clicked(element)
		{ 
			var checked=$(element).prop("checked");
			var i=$(element).val();
			
			//we modify the propriety
			var asses_session = JSON.parse(localStorage.getItem("asses_session"));
			asses_session.attributes[i].checked=checked; 
			 
			//we update the assess_session storage 
			localStorage.setItem("asses_session", JSON.stringify(asses_session));
		
		}



		

        
    });
</script>
</body>

</html>
