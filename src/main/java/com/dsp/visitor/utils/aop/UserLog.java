package com.dsp.visitor.utils.aop;

import com.dsp.visitor.entity.HandleLog;
import com.dsp.visitor.entity.User;
import com.dsp.visitor.services.LogServiceImpl;
import com.dsp.visitor.utils.HttpUtil;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.core.LocalVariableTableParameterNameDiscoverer;
import org.springframework.expression.Expression;
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.common.TemplateParserContext;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.StandardEvaluationContext;

import javax.annotation.Resource;
import java.lang.reflect.Method;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * 用于记录日志
 *
 */

public class UserLog {

    @Resource(name = "LogServiceImpl")
    private LogServiceImpl logService;

    /**
     * 缓存标注有自定义日志注解的方法参数名称
     */
    private Map<String, String[]> parameterNameCaches = new ConcurrentHashMap<String, String[]>();
    /**
     * 缓存SPEL Expression
     */
    private Map<String, Expression> spelExpressionCaches = new ConcurrentHashMap<String, Expression>();
    /**
     * Spel表达式语法分析式
     */
    private ExpressionParser parser = new SpelExpressionParser();
    /**
     * 用于获取方法参数名称数组
     */
    private LocalVariableTableParameterNameDiscoverer parameterNameDiscovere =
            new LocalVariableTableParameterNameDiscoverer();

    /**
     * 解析执行description中的SPEL模板。
     *
     * @param template
     * @param joinPoint
     * @return
     */
    private String executeTemplate(String template, JoinPoint joinPoint) {
        //获取原始对象方法名
        String methodLongName = joinPoint.getSignature().toLongString();
        String[] parameterNames = parameterNameCaches.get(methodLongName);
        if (parameterNames == null) {
            Method method = getMethod(joinPoint);
            parameterNames = parameterNameDiscovere.getParameterNames(method);
            parameterNameCaches.put(methodLongName, parameterNames);
        }
        StandardEvaluationContext context = new StandardEvaluationContext();
        Object[] args = joinPoint.getArgs();
        if (args.length == parameterNames.length) {
            for (int i = 0, len = args.length; i < len; i++) {
                context.setVariable(parameterNames[i], args[i]);
            }
        }
        Expression expression = spelExpressionCaches.get(template);
        if (expression == null) {
            expression = parser.parseExpression(template, new TemplateParserContext());
            spelExpressionCaches.put(template, expression);
        }
        return expression.getValue(context, String.class);
    }

    /**
     * 获取当前执行的方法
     *
     * @param joinPoint
     * @return
     */
    private Method getMethod(JoinPoint joinPoint) {
        Object target = joinPoint.getTarget();
        Method method = ((MethodSignature) joinPoint.getSignature()).getMethod();
        try {
            method = target.getClass().getMethod(method.getName(), method.getParameterTypes());
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
        return method;
    }

    public void userDescribeLog(JoinPoint joinPoint, Describe describe){

        if(describe != null){

            String opModule = describe.opModule();
            Integer opType = describe.opType();
            String content = describe.opContent();
            String opContent = executeTemplate(content,joinPoint);

            //System.out.println("日志信息：【+"+opContent+"】");

            String className = joinPoint.getSignature().getDeclaringTypeName();
            String name = joinPoint.getSignature().getName();

            User user = HttpUtil.getSessionUser();

            HandleLog log = new HandleLog();

            log.setUserId(user.getId());
            log.setUserName(user.getRole().getName()+"："+user.getTrueName());

            log.setOpMethod(className+" > "+name);

            log.setOpContent(opContent);
            log.setOpModule(opModule);
            log.setOpType(opType);

            //log.setAddTime(new Timestamp(System.currentTimeMillis()));

            try{
                logService.add(log);
            }catch (Exception e){
                e.printStackTrace();
            }

        }
    }
}
