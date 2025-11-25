// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'preview_page.dart';

// class CapturePage extends StatefulWidget {
//   const CapturePage({super.key});

//   @override
//   State<CapturePage> createState() => _CapturePageState();
// }

// class _CapturePageState extends State<CapturePage> {
//   dynamic _image; // File (mobile) or Uint8List (web/desktop)

//   Future<void> _getImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: source);

//     if (picked != null) {
//       if (kIsWeb) {
//         final bytes = await picked.readAsBytes();
//         setState(() => _image = bytes);
//       } else {
//         setState(() => _image = File(picked.path));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = MediaQuery.of(context).size.width > 800;
//     final double containerHeight = isDesktop ? 400 : 250;
//     final double containerWidth = isDesktop ? 400 : double.infinity;
//     final double buttonWidth = isDesktop ? 180 : double.infinity;

//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFB2DFDB), Color(0xFF81C784)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: isDesktop ? 50 : 20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "📸 Capture or Upload Photo",
//                     style: TextStyle(
//                       fontSize: isDesktop ? 26 : 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: isDesktop ? 35 : 20),

//                   // Image Preview
//                   Container(
//                     height: containerHeight,
//                     width: containerWidth,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.white38),
//                     ),
//                     child: _image != null
//                         ? ClipRRect(
//                             borderRadius: BorderRadius.circular(20),
//                             child: kIsWeb
//                                 ? Image.memory(
//                                     _image,
//                                     fit: BoxFit.contain,
//                                   )
//                                 : Image.file(
//                                     _image,
//                                     fit: BoxFit.contain,
//                                   ),
//                           )
//                         : Center(
//                             child: Text(
//                               "No photo selected",
//                               style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: isDesktop ? 16 : 14),
//                             ),
//                           ),
//                   ),
//                   SizedBox(height: isDesktop ? 30 : 15),

//                   // Capture / Upload Buttons
//                   Wrap(
//                     spacing: 16,
//                     runSpacing: 12,
//                     alignment: WrapAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: buttonWidth,
//                         child: ElevatedButton.icon(
//                           onPressed: () => _getImage(ImageSource.camera),
//                           icon: Icon(Icons.camera_alt, size: 18),
//                           label: const Text("Camera"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF388E3C),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 10),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: buttonWidth,
//                         child: ElevatedButton.icon(
//                           onPressed: () => _getImage(ImageSource.gallery),
//                           icon: Icon(Icons.photo_library, size: 18),
//                           label: const Text("Gallery"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF388E3C),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 10),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: isDesktop ? 25 : 15),

//                   // Continue Button
//                   SizedBox(
//                     width: buttonWidth,
//                     child: ElevatedButton(
//                       onPressed: _image != null
//                           ? () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) =>
//                                       PreviewPage(image: _image),
//                                 ),
//                               );
//                             }
//                           : null,
//                       child: const Text("Continue"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: _image != null
//                             ? Colors.white
//                             : Colors.white54,
//                         foregroundColor: const Color(0xFF2E7D32),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 10),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: isDesktop ? 20 : 10),
//                   Text(
//                     "Select a healthy or infected tea leaf image 🌿",
//                     style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: isDesktop ? 13 : 12),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

const CapturePage = () => {
  const [image, setImage] = useState(null);
  const navigate = useNavigate();

  const handleSelectImage = (event) => {
    const file = event.target.files[0];
    if (!file) return;

    const previewUrl = URL.createObjectURL(file);
    setImage(previewUrl);
  };

  const handleContinue = () => {
    if (!image) return;
    navigate("/preview", { state: { image } });
  };

  const isDesktop = window.innerWidth > 800;
  const containerHeight = isDesktop ? 400 : 250;
  const containerWidth = isDesktop ? 400 : "100%";
  const buttonWidth = isDesktop ? 180 : "100%";

  return (
    <div
      style={{
        width: "100vw",
        height: "100vh",
        background: "linear-gradient(to bottom right, #B2DFDB, #81C784)",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        padding: isDesktop ? "0 50px" : "0 20px",
      }}
    >
      <div style={{ textAlign: "center", width: isDesktop ? "50%" : "100%" }}>
        <h2
          style={{
            fontSize: isDesktop ? "26px" : "20px",
            fontWeight: "bold",
            color: "white",
          }}
        >
          📸 Capture or Upload Photo
        </h2>

        {/* Image preview */}
        <div
          style={{
            height: containerHeight,
            width: containerWidth,
            margin: "25px auto",
            borderRadius: "20px",
            border: "1px solid rgba(255,255,255,0.4)",
            background: "rgba(255,255,255,0.15)",
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
            overflow: "hidden",
          }}
        >
          {image ? (
            <img
              src={image}
              alt="preview"
              style={{ width: "100%", height: "100%", objectFit: "contain" }}
            />
          ) : (
            <p style={{ color: "rgba(255,255,255,0.7)" }}>No photo selected</p>
          )}
        </div>

        {/* Camera Button */}
        <label
          style={{
            width: buttonWidth,
            display: "inline-block",
            margin: "8px",
          }}
        >
          <input
            type="file"
            accept="image/*"
            capture="environment"
            style={{ display: "none" }}
            onChange={handleSelectImage}
          />
          <button
            style={{
              width: "100%",
              backgroundColor: "#388E3C",
              color: "white",
              padding: "10px 20px",
              borderRadius: "12px",
              border: "none",
              cursor: "pointer",
            }}
          >
            📷 Camera
          </button>
        </label>

        {/* Gallery Button */}
        <label
          style={{
            width: buttonWidth,
            display: "inline-block",
            margin: "8px",
          }}
        >
          <input
            type="file"
            accept="image/*"
            style={{ display: "none" }}
            onChange={handleSelectImage}
          />
          <button
            style={{
              width: "100%",
              backgroundColor: "#388E3C",
              color: "white",
              padding: "10px 20px",
              borderRadius: "12px",
              border: "none",
              cursor: "pointer",
            }}
          >
            🖼️ Gallery
          </button>
        </label>

        {/* Continue Button */}
        <button
          disabled={!image}
          onClick={handleContinue}
          style={{
            width: buttonWidth,
            marginTop: "18px",
            backgroundColor: image ? "white" : "rgba(255,255,255,0.6)",
            color: "#2E7D32",
            padding: "10px 20px",
            borderRadius: "12px",
            border: "none",
            cursor: image ? "pointer" : "not-allowed",
            fontWeight: "bold",
          }}
        >
          Continue
        </button>

        <p
          style={{
            marginTop: "12px",
            color: "rgba(255,255,255,0.7)",
            fontSize: isDesktop ? "13px" : "12px",
          }}
        >
          Select a healthy or infected tea leaf image 🌿
        </p>
      </div>
    </div>
  );
};

export default CapturePage;
