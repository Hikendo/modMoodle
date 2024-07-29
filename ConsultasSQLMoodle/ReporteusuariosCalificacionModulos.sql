SELECT 
    CONCAT(u.firstname, ' ', u.lastname) AS Nombre_Completo,
    u.institution AS Institucion,
    u.department AS Maestria,
    u.city AS Campus,
    u.country AS Pais,
    c.fullname AS Examen,
    q.name AS Modulo,
    CAST(qa.sumgrades AS UNSIGNED) AS TotalRespuestaCorrectas,
    gg.finalgrade AS Calificacion
FROM 
    prefix_user u
JOIN 
    prefix_user_enrolments ue ON u.id = ue.userid
JOIN 
    prefix_enrol e ON ue.enrolid = e.id
JOIN 
    prefix_course c ON e.courseid = c.id
JOIN 
    prefix_context cx ON c.id = cx.instanceid
JOIN 
    prefix_role_assignments ra ON u.id = ra.userid AND ra.contextid = cx.id
JOIN 
    prefix_role r ON ra.roleid = r.id
JOIN 
    prefix_quiz q ON c.id = q.course
JOIN 
    prefix_quiz_attempts qa ON q.id = qa.quiz AND u.id = qa.userid
JOIN 
    prefix_grade_items gi ON gi.iteminstance = q.id AND gi.itemmodule = 'quiz'
JOIN 
    prefix_grade_grades gg ON gg.itemid = gi.id AND gg.userid = u.id
JOIN
    prefix_groups_members gm ON gm.userid = u.id
JOIN
    prefix_groups g ON g.id = gm.groupid
WHERE 
    c.id = :course_id
    AND r.shortname = 'student_exam'
    AND qa.state = 'finished'
    AND g.name = :group_name -- Reemplaza con el nombre del grupo deseado
ORDER BY 
    u.lastname, u.firstname, q.name, qa.timefinish
