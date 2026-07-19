import 'package:amazon_cognito_identity_dart_2/cognito.dart';
export 'package:amazon_cognito_identity_dart_2/cognito.dart';

class CognitoService {
  static const userPoolId = String.fromEnvironment('COGNITO_USER_POOL_ID');
  static const clientId = String.fromEnvironment('COGNITO_CLIENT_ID');

  static final userPool = CognitoUserPool(userPoolId, clientId);

  //Registro de usuarios en Cognito
  Future<CognitoUserPoolData> registro(String email, String password) async{
    final userAttributes = [
      AttributeArg(name: 'email', value: email)
    ];

    return await userPool.signUp(
      email,
      password, 
      userAttributes: userAttributes
    );
  }

  // Confirmar código de verificación (Lo manda por email)
  Future<bool> confirmarIngreso(String email, String code) async{
    final cognitoUser =  CognitoUser(email, userPool);
    return await cognitoUser.confirmRegistration(code);
  }

  //Login
  Future<CognitoUserSession?> ingresar(String email, String password) async{
    final cognitoUser = CognitoUser(email, userPool);
    final authDetails =  AuthenticationDetails(
      username: email,
      password: password
    );

    try{
        final sesion = await cognitoUser.authenticateUser(authDetails);
        return sesion;
    } on CognitoUserNewPasswordRequiredException catch(e){
      //Si es primera vez logueando, cognito te pide actualizar tu contraseña por seguridad
      print('Se requiere que actualices tu contraseña: $e');
      rethrow;
    } catch (e){
      print('Error de ingreso de sesión: $e');
      rethrow;
    }
  }

  // Obtener el JWT generado por Cognito
  Future<String?> getIdToken() async{
    final usuarioActual = await userPool.getCurrentUser();
    if(usuarioActual == null) return null;
    final sesion = await usuarioActual.getSession();
    return sesion?.getIdToken().getJwtToken();
  }

  // Cerrar sesión de incognito
  Future<void> cerrarSesion() async {
    final user = await userPool.getCurrentUser();
    await user?.signOut();
  }



}