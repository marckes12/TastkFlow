import 'package:flutter/material.dart';
import 'package:taskflow/core/auth/cognito_service.dart';

class CognitoTestView extends StatefulWidget {
  const CognitoTestView({super.key});

  @override
  State<CognitoTestView> createState() => _CognitoTestViewState();
}

class _CognitoTestViewState extends State<CognitoTestView> {
  final cognitoService = CognitoService();
  final emailController =  TextEditingController(text: 'marckesgarcia@gmail.com');
  final passwordController =  TextEditingController(text: 'M@rck4316');
  final codeController = TextEditingController();
  String request = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logueo Cognito'),),
      body:  Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Correo electronico'),
            ),

            //Password
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),

            const SizedBox(height: 20,),

            //Boton de registro
            ElevatedButton(
              onPressed: () async{
                try{
                  await cognitoService.registro(
                    emailController.text,
                    passwordController.text
                  );

                  setState(() {
                    request =  'Registrado: Revisa tu correo para validar';
                  });
                } catch (e){
                  setState(() {
                    request =  'Error de logueo: \n$e';
                  });
                }
              }, 
              child: const Text('Regitrar usuario'),
            ),

            const SizedBox(height: 20,),

            //Código del correo
            TextField(
              controller: codeController,
              decoration: const InputDecoration(labelText: 'Código del correo'),
            ),

            ElevatedButton(
              onPressed: () async{
                try{
                  final ok = await cognitoService.confirmarIngreso(
                    emailController.text, 
                    codeController.text
                  );

                  setState(() {
                    request =  'Usuario confirmado: $ok';
                  });
                } catch (e){
                  setState(() {
                    request =  'Error de confirmación: $e';
                  });
                }
              }, 
              child: const Text('Confirma código'),
            ),

            const SizedBox(height: 20,),
            
            ElevatedButton(
              onPressed: () async{
                try{
                  final session = await cognitoService.ingresar(
                    emailController.text,
                    passwordController.text
                  );

                  final token = session?.getIdToken().getJwtToken();
                  setState(() {
                    request =  'Token:  ${token?.substring(0, 40)} ...';
                  });
                } catch (e){
                  setState(() {
                    request =  'Error de logueo: $e';
                  });
                }
              }, 
              child: const Text('Ingresar'),
            ),

            const SizedBox(height: 20,),  
            Text(request, style: const TextStyle(fontSize: 12)),

          ],
        ),
      
      ),
    );
  }
}