import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../api_endpoints.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiEndPoints.baseUrlUat)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  /// ==============================
  /// AUTHENTICATION ENDPOINTS
  /// ==============================

  @POST("Auth/Login")
  Future<HttpResponse<dynamic>> login(@Body() Map<String, dynamic> body);

  /// ==============================
  /// COMPANY ENDPOINTS
  /// ==============================

  @GET("Company/GetCompanyList")
  Future<HttpResponse<dynamic>> getCompanyList();

  /// ==============================
  /// JOB ENDPOINTS
  /// ==============================

  @GET("Job/GetNextJobNumber")
  Future<HttpResponse<dynamic>> getNextJobNumber();

  @GET("Job/GetJobDate")
  Future<HttpResponse<dynamic>> getJobDate();

  @GET("Job/GetJobStatusList")
  Future<HttpResponse<dynamic>> getJobStatusList();

  @GET("Job/GetJobTypeList")
  Future<HttpResponse<dynamic>> getJobTypeList();

  @GET("Job/GetAllocatedEmployeeList")
  Future<HttpResponse<dynamic>> getAllocatedEmployeeList();

  @GET("Job/GetReportingEmployeeList")
  Future<HttpResponse<dynamic>> getReportingEmployeeList();

  @POST("Job/CreateJob")
  Future<HttpResponse<dynamic>> createJob(@Body() Map<String, dynamic> body);

  @POST("Job/GetJobList")
  Future<HttpResponse<dynamic>> getJobList(@Body() Map<String, dynamic> body);

  /// ==============================
  /// PROJECT ENDPOINTS
  /// ==============================

  @GET("Project/GetProjectList")
  Future<HttpResponse<dynamic>> getProjectList();

  @GET("Project/GetTitlesForProject")
  Future<HttpResponse<dynamic>> getTitlesForProject(
    @Query("ProjectId") String projectId,
  );

  @GET("Project/GetCustomersForProject")
  Future<HttpResponse<dynamic>> getCustomersForProject();

  /// ==============================
  /// USER ENDPOINTS
  /// ==============================

  @POST("User/ListUser")
  Future<HttpResponse<dynamic>> listUser(@Body() Map<String, dynamic> body);


}
