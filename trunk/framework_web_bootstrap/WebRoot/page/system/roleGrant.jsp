<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<script type="text/javascript">
	var resourceTree;
	$(function() {
		resourceTree = $('#resourceTree').tree({
			url : '${CONTEXT_PATH}/system/res/tree?type=2',
			parentField : 'pid',
			//lines : true,
			checkbox : true,
			onClick : function(node) {
			},
			onLoadSuccess : function(node, data) {
				var ids = $.stringToList('${param.resIds}');
				if (ids.length > 0) {
					for ( var i = 0; i < ids.length; i++) {
						if (resourceTree.tree('find', ids[i])) {
							resourceTree.tree('check', resourceTree.tree('find', ids[i]).target);
						}
					}
				}
				$('#roleGrantLayout').layout('panel', 'west').panel('setTitle', $.formatString('[{0}]角色可以访问的资源', '${param.name}'));
				parent.$.messager.progress('close');
			},
			cascadeCheck : false
		});

		$('#fm').form({
			url : '${CONTEXT_PATH}/system/role/grant',
			onSubmit : function() {
				/**
				parent.$.messager.progress({
					title : '提示',
					text : '数据处理中，请稍后....'
				});
				var isValid = $(this).fm('validate');
				if (!isValid) {
					parent.$.messager.progress('close');
				}
				**/
				
				var checknodes = resourceTree.tree('getChecked');
				var ids = [];
				if (checknodes && checknodes.length > 0) {
					for ( var i = 0; i < checknodes.length; i++) {
						ids.push(checknodes[i].id);
					}
				}
				$('#res_ids').val(ids);
				return true;
			},
			success : function(result) {
				parent.$.messager.progress('close');
				result = parent.$.parseJSON(result);
				console.log(result);
				if (result.code==200) {
					
					parent.$.modalDialog.openner_treeGrid.treegrid('reload');
					parent.$.modalDialog.handler.dialog('close');
					 parent.layout_west_tree.tree('reload');
				}
				else  $.messager.alert('提示',result.msg);
			}
		});
	});

	function checkAll() {
		var nodes = resourceTree.tree('getChecked', 'unchecked');
		if (nodes && nodes.length > 0) {
			for ( var i = 0; i < nodes.length; i++) {
				resourceTree.tree('check', nodes[i].target);
			}
		}
	}
	function uncheckAll() {
		var nodes = resourceTree.tree('getChecked');
		if (nodes && nodes.length > 0) {
			for ( var i = 0; i < nodes.length; i++) {
				resourceTree.tree('uncheck', nodes[i].target);
			}
		}
	}
	function checkInverse() {
		var unchecknodes = resourceTree.tree('getChecked', 'unchecked');
		var checknodes = resourceTree.tree('getChecked');
		if (unchecknodes && unchecknodes.length > 0) {
			for ( var i = 0; i < unchecknodes.length; i++) {
				resourceTree.tree('check', unchecknodes[i].target);
			}
		}
		if (checknodes && checknodes.length > 0) {
			for ( var i = 0; i < checknodes.length; i++) {
				resourceTree.tree('uncheck', checknodes[i].target);
			}
		}
	}
</script>
<div id="roleGrantLayout" class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'west'" title="系统资源" style="width: 300px; padding: 1px;">
		<div class="well well-small">
			<form id="fm" method="post">
				<input name="role.id" type="hidden" class="span2" value="${param.id}" readonly="readonly">
				<ul id="resourceTree"></ul>
				<input id="res_ids" name="res_ids" type="hidden" />
			</form>
		</div>
	</div>
	<div data-options="region:'center'" title="" style="overflow: hidden; padding: 10px;">
		<div class="well well-small">
			<span class="label label-success">${param.name}</span>
		</div>
		<div class="well well-large">
			<button class="btn btn-success" onclick="checkAll();">全选</button>
			<br /> <br />
			<button class="btn btn-warning" onclick="checkInverse();">反选</button>
			<br /> <br />
			<button class="btn btn-inverse" onclick="uncheckAll();">取消</button>
		</div>
	</div>
</div>