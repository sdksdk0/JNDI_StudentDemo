package cn.tf.student.dao;

import java.util.ArrayList;
import java.util.List;

import cn.tf.student.entity.Student;
import cn.tf.student.utils.DBHelper;
import cn.tf.student.utils.DBHelper1;

public class StudentDao {

	private DBHelper  db=new DBHelper();
	
	public int add(String cid,String sname,String age,String  tel,String photo){
		
		String sql="insert into student values(0,?,?,?,?,?)";
		List<Object>  params =new ArrayList<Object>();
		params.add(cid);
		params.add(sname);
		params.add(age);
		params.add(tel);
		params.add(photo);
		return db.update(sql, params);
		
	}
	
	public List<Student> find(){
		String sql="select s.*,cname from student s,classes c where s.cid=c.cid";
		return db.find(sql, null, Student.class);
		
	}
	
	
}
