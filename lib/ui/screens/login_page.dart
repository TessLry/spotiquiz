import 'package:flutter/material.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotiquiz/router.dart';
import 'package:spotiquiz/utils/colors.dart';
import 'package:spotiquiz/utils/credentials.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Future<void> _handleLoginWithSpotify(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    await SpotifySdk.connectToSpotifyRemote(
        clientId: AppCredentials.spotifyId,
        redirectUrl: AppCredentials.redirectUrl);

    String token = await SpotifySdk.getAccessToken(
        clientId: AppCredentials.spotifyId,
        redirectUrl: AppCredentials.redirectUrl,
        scope:
            "app-remote-control,user-modify-playback-state,playlist-read-private");

    AppCredentials.accessToken = token;

    if (context.mounted) {
      Navigator.pushNamed(context, AppRouter.homePage);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                width: 60,
                height: 60,
                child: Image(
                  color: AppColors.white,
                  image: AssetImage('assets/spotify.png'),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Des millions d\'artistes.\nUne seule réponse.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  letterSpacing: -0.5,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: Image.asset('assets/spotify.png',
                    width: 35, color: AppColors.black),
                onPressed: () => _handleLoginWithSpotify(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                label: const Text(
                  'Continuer avec Spotify',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
