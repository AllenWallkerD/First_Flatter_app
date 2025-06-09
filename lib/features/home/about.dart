import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import '../../styles/signinStyles.dart';

@RoutePage()
class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool? isMenSelected;
  String? selectedAgeRange;
  String? _errorMessage;

  final List<String> ageRanges = [
    "Under 18",
    "18-24",
    "25-34",
    "35-44",
    "45-54",
    "55+",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FF), 
      body: SafeArea(
        child: Padding(
          padding: SignInStyles.formPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Tell us About yourself",
                style: SignInStyles.titleTextStyle,
              ),
              SignInStyles.largeSpacing,

              const Text(
                "Who do you shop for?",
                style: SignInStyles.normalTextStyle,
              ),
              SignInStyles.spacing,

              Row(
                children: [
                  Expanded(
                    child: _genderButton(
                      label: "Men",
                      selected: isMenSelected == true,
                      onTap: () => setState(() => isMenSelected = true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _genderButton(
                      label: "Women",
                      selected: isMenSelected == false,
                      onTap: () => setState(() => isMenSelected = false),
                    ),
                  ),
                ],
              ),
              SignInStyles.largeSpacing,

              const Text(
                "How Old are you?",
                style: SignInStyles.normalTextStyle,
              ),
              SignInStyles.spacing,

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: selectedAgeRange,
                  hint: const Text("Age Range"),
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ageRanges.map((range) {
                    return DropdownMenuItem<String>(
                      value: range,
                      child: Text(range),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAgeRange = value;
                    });
                  },
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16), 
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            style: SignInStyles.primaryButtonStyle,
            onPressed: _onFinish,
            child: const Text(
              "Finish",
              style: SignInStyles.buttonTextStyle,
            ),
          ),
        ),
      ),
    );
  }

Widget _genderButton({
  required String label,
  required bool selected,
  required VoidCallback onTap,
}) {
  final ButtonStyle style = selected
      ? SignInStyles.primaryButtonStyle
      : ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: const BorderSide(color: Colors.grey),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12), 
        );

  final TextStyle textStyle = selected
      ? SignInStyles.buttonTextStyle
      : const TextStyle(color: Colors.black);

  return SizedBox(
    height: 45, 
    child: ElevatedButton(
      onPressed: onTap,
      style: style,
      child: Text(label, style: textStyle), 
    ),
  );
}

  void _onFinish() {
    setState(() {
      _errorMessage = null;
    });

    if (isMenSelected == null) {
      setState(() {
        _errorMessage = "Please select who you shop for (Men or Women).";
      });
      return;
    }

    if (selectedAgeRange == null) {
      setState(() {
        _errorMessage = "Please select your age range.";
      });
      return;
    }

    Navigator.pushNamed(context, '/signIn');
  }
}
