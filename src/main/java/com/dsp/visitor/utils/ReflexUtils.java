package com.dsp.visitor.utils;

import com.github.andyczy.java.excel.ExcelUtils;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.lang.reflect.Field;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

/**
 * 
 * 反射工具类
 * 
 */
public class ReflexUtils {


    /**
     * 将execl文件转换为对象集合
     * @param clazz
     * @param file
     * @param <T>
     * @return
     */
    public static <T> List<T> execlToList(Class<T> clazz, MultipartFile file){

        List<T> list = new ArrayList<>();
        Workbook workbook = null;
        try {
            workbook = WorkbookFactory.create(file.getInputStream());
        } catch (IOException e) {
            e.printStackTrace();
        }

        List<List<LinkedHashMap<String, String>>> lists = ExcelUtils.importForExcelData(workbook, new String[]{"sheet1"}, null, null);

        List<LinkedHashMap<String,String>> excels = lists.get(0);

        for(LinkedHashMap<String,String> cell : excels) {

            T entity = toObject(clazz, cell);

            list.add(entity);
        }
        return list;
    }


    /**
     * 转换格式
     * @param userList
     * @return
     */
    public static <T> List<List<String[]>> exportSet(List<T> userList,String[] headers){

        List<List<String[]>> dataLists = new ArrayList<>();
        /**
         * 多表导出，设置第一个表
         */
        List<String[]> oneList = new ArrayList<>();
        //String[] headers = {"编号","账号","密码","昵称","真实姓名","部门","邮箱","用户备注","创建时间"};
        oneList.add(headers);

        for(T user : userList){

            String[] valueString = objectToString(user);

            oneList.add(valueString);

        }
        //List<String[]> twoList = new ArrayList<>();  // 表格二数据（和表一相同）

        dataLists.add(oneList);

        return dataLists;
    }

    /**
     *
     * 将行元素转换为类对象
     *
     * @param clazz 要转换为的对象类型
     * @param cell 转换前的行元素
     */
    public static <T> T toObject(Class<T> clazz, LinkedHashMap<String,String> cell){
    
        /*
            得到类中的所有属性集合
             */
        Field[] fs = clazz.getDeclaredFields();
        T entity = null;
        try {
            entity = (T)clazz.newInstance();
        } catch (InstantiationException | IllegalAccessException e) {
            e.printStackTrace();
        }

        for (int i = 0; i < fs.length; i++) {
            Field f = fs[i];
            //设置属性可以访问
            f.setAccessible(true);

            try {
                String type = f.getType().getName();
                //给属性赋值
                if("java.lang.Integer".equals(type)){
                    f.set(entity,Integer.parseInt(cell.get(i+"")));
                }else if("java.lang.Double".equals(type) || "java.lang.Float".equals(type)){
                    f.set(entity,Double.parseDouble(cell.get(i+"")));
                }else if("java.util.Date".equals(type)) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    f.set(entity,sdf.parse(cell.get(i+"")));
                }else {
                    f.set(entity,cell.get(i+""));
                }

            } catch (IllegalArgumentException | IllegalAccessException | ParseException e) {
                e.printStackTrace();
            }
        }

        return entity;
        
    }

    /**
     *
     * 将类对象转换为行元素
     *
     * @param entity 要转换的对象
     *
     */
    public static <T> String[] objectToString(T entity) {

        Class userClass = entity.getClass();
        String[] valueString = null;
            /*
            得到类中的所有属性集合
             */
        Field[] fs = userClass.getDeclaredFields();
        valueString = new String[fs.length];
        for (int i = 0; i < fs.length; i++) {
            Field f = fs[i];
            /**
             * 设置属性可以访问
             */
            f.setAccessible(true);
            Object val = null;

            try {

                val = f.get(entity);

                if("java.util.Date".equals(f.getType().getName())){
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    valueString[i] = sdf.format(val);
                }else{
                    valueString[i] = val.toString();
                }
                // 得到此属性的值
            } catch (IllegalArgumentException | IllegalAccessException e) {
                e.printStackTrace();
            }
        }
        return valueString;
    }

}
