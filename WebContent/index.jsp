<%@page import="cn.tf.student.utils.DBHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<head>
<meta  charset="UTF-8">
<title>添加</title>
</head>

<script src="js/jquery-3.1.0.js"  ></script>
<body>

	<fieldset>
	
		<legend>添加班级</legend>
		　<form   method="post" >
			班级名称:<input type="text"  name="cname"  id="cname"/>
			<input type="button"  value="添加班级"   onclick="addClasses()" 　/><span></span>

		</form>
	</fieldset>
	<fieldset>
		<legend>添加学生</legend>
		<form action=""  method="post"  id="add_student">
		
			班级:<select name="cid"  id="classesInfo" >
			
			
			</select>
			姓名:<input type="text"  name="sname"  id="sname" />
			年龄:<input type="number" name="age"  min="1"  id="age" />
			联系方式:<input type="text" name="tel" id="tel" />
			图片:<input type="file" name="photo"  />
			<input type="button"  value="添加"   onclick="addStudent()" />

		</form>
	
	</fieldset>
	<fieldset>
		<legend>学生信息浏览</legend>
		<table border="1px" cellspacing="0px" cellpaddig="0px" width="90%"  align="center"  style="border-collapse:collapse;"  >
			<thead>
				<tr>
					<th>图片</th>
					<th>学号</th>
					<th>姓名</th>
					<th>年龄</th>
					<th>联系方式</th>
					<th>所在班级</th>
				</tr>
			
			</thead>
			<tbody id="show_student"  align="center"  ></tbody>
		
		</table> 
	
	
	</fieldset>


	<script>
	
		function addClasses(){
			var cname=$.trim($("#cname").val());
			if(cname==""){
				$("#cname").next().next().text(" 请输入班级名称").css("color","red");
			}else{
				$.post("doaddclasses.jsp",{op:'addClasses',cname:cname},function(data){
					data=parseInt($.trim(data));
					if(data>0){
						$("#cname").next().next().text("班级信息添加成功").css("color","green");
						$("#cname").val("");
					}else{
						$("#cname").next().next().text("班级信息添加失败").css("color","red");
					}
				});
			}
			
			
		}
		
		/* $(function(){
				$.post("doaddclasses.jsp",{op:"findClasses"},function(data){
					data=$.trim(data);
					if(data!=""){
						var arr=data.split(",");
						for(var i=0;i<arr.length;i++){
							var cls=arr[i].split("-");
							$("#classesInfo").append($("<option value='"+cls[0]+"'>"+cls[1]+"</option>"));
						}
					}
				});
		}); */
	
		
		$(function(){
			$.post("doaddclasses.jsp",{op:"findClasses"},function(data){
				
				if(data!=""){
					$.each(data,function(index,item){
						$("#classesInfo").append($("<option value='"+item.cid+"'>"+item.cname+"</option>"));
					});
				}
			},"json");
	});
		
		
		
		function addStudent(){
			var sname=$.trim($("#sname").val());
			var age=$.trim($("#age").val());
			var tel=$.trim($("#tel").val());
			var cid=$.trim($("#classesInfo").val());
			
			
			$.post("dostudent.jsp",{op:"addStudent",sname:sname,age:age,tel:tel,cid:cid},function(data){
				if(data==null){
					alert("数据添加失败");
				}else{
					$("#sname").val("");
					$("#age").val("");
					$("#tel").val("");
					$("#show_student").html("");

					$.each(data,function(index,item){
						$("#show_student").append("<tr><td></td><td>"+item.sid+"</td><td>"+item.sname+"</td><td>"+item.age+"</td><td>"+item.tel+"</td><td>"+item.cname+"</td></tr>");
							
					});
				}
			},"json");
		}
	
	
	</script>

</body>
</html>