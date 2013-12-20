<%@ page contentType="text/html; charset=utf-8" %>
<!-- GroupStrategy的输入弹出框 -->
<form id="groupStrategyFrom" class="form-horizontal" method="post">
	<div id="groupStrategyModal" class="modal hide fade" tabindex="-1"
		role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<div id="header1">
				<strong>第一步 </strong>请粘贴分组策略代码
			</div>
			<div class="hide" id="header2">
				<strong>第二步 </strong>设置类型
			</div>
		</div>
		<div class="modal-body" id="groupStrategyDiv1" style="height:360px;" >
			<div  id="alertErrorDiv"></div>
			<div class="control-group" style="margin-top: 0px;">
				<label class="control-label" style="width: 50px;"> </label>
				<div class="controls" style="margin-left: 5px;">
					<textarea id="srcCode" name="srcCode" placeholder="请在此粘贴自定义的分组策略的代码..."
						class="span7" rows="16" cols="80"></textarea>
				</div>
			</div>
		</div>
		<div class="modal-body" style="display:none;height:360px;" id="groupStrategyDiv2">
			<div class="control-group">
				<label class="control-label">名字 <i tips="" data-trigger="hover" class="icon-question-sign"
					data-toggle="popover" data-placement="top"
					data-original-title="提示" data-content="只支持字母，数字和下划线的名字，例如：WebShop_2"></i>
				</label>
				<div class="controls">
					<input type="text" name="name" id="groupStrategyName" check-type="required" required-message="请输入分组策略的名字">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">类名 </label>
				<div class="controls">
					<input type="text" name="className"  readonly="readonly">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">全名 </label>
				<div class="controls">
					<input type="text" name="fullyQualifiedName"  readonly="readonly">
				</div>
			</div>
			<div id="groupStrategyDiv2sub">
			
			</div>
		</div>
		<div class="modal-footer">
			<button class="btn" data-dismiss="modal" aria-hidden="true">取消</button>
			<button class="btn btn-primary" id="submitGroupStrategy">下一步</button>
			<button class="btn btn-primary" id="submitGroupStrategyOK" aria-hidden="true" disabled="true">确定</button>
		</div>
	</div>
</form>

<script type="text/javascript">
$(document).ready(function() {
	$("#submitGroupStrategy").click(function(e) {
		if($('#submitGroupStrategy').text() == '下一步'){
			if($('#srcCode').val().length == 0){
				var innerHTML = '<div class="alert  alert-error" style="margin-bottom: 5px;"><button type="button" class="close" data-dismiss="alert">&times;</button><span>请粘贴自定义的分组策略的代码...</span></div>';
				$('#alertErrorDiv').html(innerHTML);
			}else{
				var params = $("#groupStrategyFrom").serialize();
				$.ajax({
					type: "POST",
					url : "abtest?op=ajax_parseGs",
					data: params
				}).done(function(json) {
					var json = JSON.parse(json);
					if($.isEmptyObject(json)){
						var innerHTML = '<div class="alert  alert-error" style="margin-bottom: 5px;"><button type="button" class="close" data-dismiss="alert">&times;</button><strong>Parse Error!</strong><span>Please paste correct source code...</span></div>';
						$('#alertErrorDiv').html(innerHTML);
					}else{
						$('#submitGroupStrategyOK').data(json);
						
						$("#groupStrategyDiv2 input").each(function(){
							var key = $(this).attr("name");
							$(this).val(json[key]);
							if(key == "fullyQualifiedName"){
								$(this).popover('destroy')
								var innerHTML = '<span style="word-break:break-all; width:200px;">' + json[key] +'</span>';
								var options = {
									"animation":true,
									"html":true,
									"placement":"top",
									"trigger":"hover",
									"content":innerHTML
								};
								$(this).popover(options);
							}
						});
						
						var innerHTML = '';
						for(var key in json.fields){
							innerHTML += '<div class="control-group"><label class="control-label">' + json.fields[key]['name'] + '</label>'
								+ '<div class="controls"><select name="" check-type="required" required-message="type is required!">'
								+ '<option value="input">input</option><option value="textarea">textarea</option></select>'
								+ '</div></div>';
						}
						
						$('#groupStrategyDiv2sub').empty();
						$('#groupStrategyDiv2sub').html(innerHTML);
						
						$('#submitGroupStrategy').text("上一步");
						$('#submitGroupStrategyOK').removeAttr("disabled");
						
						$('#header2').show();
						$('#groupStrategyDiv2').show();
						$('#header1').hide();
						$('#groupStrategyDiv1').hide();
						
						//$('#groupStrategyFrom').validation();
					}
				}).fail(function(){
					alert("fail");
				});
			}
		}else{
			$('#header1').show();
			$('#groupStrategyDiv1').show();
			$('#submitGroupStrategy').text("下一步");
			$('#header2').hide();
			$('#groupStrategyDiv2').hide();
		}

	});
	
	$('#submitGroupStrategyOK').click(function(e){
		//e.preventDefault();
		var name = $('#groupStrategyName').val();
		
		if(name != ""){
			var json = $(this).data();
			
			for(var i in json.fields){
				json.fields[i]['inputType'] = $("#groupStrategyDiv2 select:eq(" + i + ")").val();
			}
			//console.log(json);

			var params = {
				'groupStrategyName' : $('#groupStrategyName').val(),
				'groupStrategyClassName' : json.className,
				'groupStrategyFullName' : json.fullyQualifiedName,
				'groupStrategyDescriptor' : JSON.stringify(json),
				'groupStrategyDescription' : ''
			};
			
			$.ajax({
				type: "POST",
				url : "abtest?op=ajax_addGs",
				data: params
			}).done(function(json) {
				json = JSON.parse(json);
				alert(json.msg);
			});
			
			$('#groupStrategyModal').modal('hide');
		}else{
			//$('#groupStrategyFrom').validation();
		}
	});
	
	$('#strategyId').change(function(){
		if($(this).val() != 0){
			//alert($(this).val());
			var jsonObject = $('#strategyId option[value=' + $(this).val() + ']').data();
			//var jsonObject = $(this).data();
			var innerHTML = "";
			
			for(var i in jsonObject['fields']){
				var field = jsonObject['fields'][i];
				
				if(field['inputType'] == "textarea"){
					innerHTML += '<div class="control-group"><label class="control-label">' + field['name'] + '</label>'
	                         + '<div class="controls"><textarea class="span6" rows="3" cols="60" name="' + field['name'] + '"></textarea></div>'
							 + '</div>';
				}else if(field['inputType'] == "input"){
					innerHTML += '<div class="control-group"><label class="control-label">' + field['name'] + '</label>'
					         + '<div class="controls"><input type="text" name="' + field['name'] + '"></div>'
				             + '</div>';
				}
			}
			
			//alert(innerHTML);
			$('#groupStrategyDivsub').empty();
			$('#groupStrategyDivsub').html(innerHTML);
		}else{
			$('#groupStrategyDivsub').empty();
		}
	});
});
</script>