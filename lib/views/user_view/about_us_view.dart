import 'package:donite/views/user_view/disasters_view.dart';
import 'package:donite/views/user_view/user_constants.dart';
import 'package:flutter/material.dart';

class AboutUsView extends StatefulWidget {
  const AboutUsView({super.key});

  @override
  State<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends State<AboutUsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar,
      backgroundColor: Colors.white,
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8.0, right: 10.0, left: 10.0),
                child: Text(
                  'About Us', // Replace with your desired text
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0, left: 12.0),
                child: Text(
                  'Welcome to DOnite!',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0, left: 12.0),
                child: Text(
                  'Your Multiplatform system for streamlining the process of Donation and Volunteerism to disaster for Bauang, La Union.',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0, left: 12.0),
                child: Text(
                  'DOnite is a versatile system designed to optimize rescue operations by facilitating the seamless reception of donations, including goods and supplies. Our platform is committed to bolstering manpower to disasters, ensuring a swift and effective response to critical situations.',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0, left: 12.0),
                child: Text(
                  'In times of crisis, panic can often hinder individuals from prioritizing their own safety, potentially leading to accidents that require immediate rescue. The DOnite addresses this challenge by significantly enhancing the capabilities of rescue teams. This, in turn, minimizes risks and ensures that help reaches affected areas with the utmost urgency.',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0, left: 12.0),
                child: Text(
                  'To ensure the successful execution of the DOnite, we adhere strictly to guidelines and regulations set forth by the Municipality of Bauang. These include compliance with Executive Order no. 28 (24/7 Operation), Executive no. 145 S.2019 (Adopting the Incident Command System), and Ordinance no. 3 S.2016 (Pre-emptive evacuation in the municipality as a resort).',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0, left: 12.0),
                child: Text(
                  'DOnite specializes in empowering volunteerism and donations to disasters. Our user-friendly platform allows individuals and organizations to expand their outreach by mobilizing manpower and collecting donations for the benefit of disaster victims. Deployed under the oversight of MDRRMO Bauang, the DOnite management system is dedicated to serving the community of Bauang, La Union.',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0, left: 12.0),
                child: Text(
                  'Join us in making a difference. Together, we can build a more resilient and supportive community in the face of adversity.',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
