class TaskDetails {
  final int? taskId;
  final int? subTaskId;
  final String? subject;
  final String? assignDt;
  final String? targetDt;
  final int? assignedEmpcode;
  final String? assignedEmploy;
  final int? requestedEmpcode;
  final String? requestedEmploy;
  final String? status;
  final String? reqType;
  final String? priority;
  final String? content;
  final String? revReqdate;
  final String? reqReason;

  TaskDetails({
    this.taskId,
    this.subTaskId,
    this.subject,
    this.assignDt,
    this.targetDt,
    this.assignedEmpcode,
    this.assignedEmploy,
    this.requestedEmpcode,
    this.requestedEmploy,
    this.status,
    this.reqType,
    this.priority,
    this.content,
    this.revReqdate,
    this.reqReason,
  });

  factory TaskDetails.fromJson(Map<String, dynamic> json) => TaskDetails(
        taskId: json['task_id'],
        subTaskId: json['sub_task_id'],
        subject: json['subject'],
        assignDt: json['assign_dt'],
        targetDt: json['target_dt'],
        assignedEmpcode: json['assigned_empcode'],
        assignedEmploy: json['Assigned_Employ'],
        requestedEmpcode: json['Requested_Empcode'],
        requestedEmploy: json['requested_employ'],
        status: json['status'],
        reqType: json['req_type'],
        priority: json['priority'],
        content: json['content'],
        revReqdate: json['Rev_reqdate'],
        reqReason: json['Req_reason'],
      );

  Map<String, dynamic> toJson() => {
        'task_id': taskId,
        'sub_task_id': subTaskId,
        'subject': subject,
        'assign_dt': assignDt,
        'target_dt': targetDt,
        'assigned_empcode': assignedEmpcode,
        'Assigned_Employ': assignedEmploy,
        'Requested_Empcode': requestedEmpcode,
        'requested_employ': requestedEmploy,
        'status': status,
        'req_type': reqType,
        'priority': priority,
        'content': content,
        'Rev_reqdate': revReqdate,
        'Req_reason': reqReason,
      };
}
