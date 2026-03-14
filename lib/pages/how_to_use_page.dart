import 'package:flutter/material.dart';

class HowToUsePage extends StatelessWidget {
  const HowToUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Use Leafcure'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFB2DFDB), Color(0xFF81C784)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 36 : 18,
              vertical: isDesktop ? 28 : 18,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeroBanner(isDesktop: isDesktop),
                    const SizedBox(height: 18),
                    const _SectionCard(
                      title: 'Use Leafcure in 4 easy steps',
                      subtitle:
                          'Follow the same order every time. You do not need to know technical terms.',
                      child: _QuickStepsDiagram(),
                    ),
                    const SizedBox(height: 18),
                    const _SectionCard(
                      title: 'Main buttons and what they do',
                      subtitle:
                          'These are the most important buttons on the home screen.',
                      child: _HomeButtonGuide(),
                    ),
                    const SizedBox(height: 18),
                    const _SectionCard(
                      title: 'Take a clear leaf photo',
                      subtitle:
                          'A clean and bright photo helps the app give a better answer.',
                      child: _PhotoTipsDiagram(),
                    ),
                    const SizedBox(height: 18),
                    const _SectionCard(
                      title: 'What happens after analysis',
                      subtitle:
                          'The app reads your photo, shows the leaf condition, and gives next-step advice.',
                      child: _ResultFlowDiagram(),
                    ),
                    const SizedBox(height: 18),
                    _HelpFooter(isDesktop: isDesktop),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Wrap(
        spacing: 18,
        runSpacing: 18,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: isDesktop ? 88 : 72,
            height: isDesktop ? 88 : 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE8F5E9),
              border: Border.all(color: const Color(0xFF81C784), width: 2),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              size: 40,
              color: Color(0xFF2E7D32),
            ),
          ),
          SizedBox(
            width: isDesktop ? 720 : double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This page is made for first-time users.',
                  style: TextStyle(
                    fontSize: isDesktop ? 26 : 21,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'If you forget a step, open the menu icon on the home screen and tap the guide again. The diagrams below show where to tap and what each screen means.',
                  style: TextStyle(
                    fontSize: isDesktop ? 15 : 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _BadgeChip(
                      icon: Icons.touch_app,
                      label: 'Plain tap-by-tap instructions',
                    ),
                    _BadgeChip(
                      icon: Icons.visibility_rounded,
                      label: 'Large icons and simple words',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1B5E20),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _QuickStepsDiagram extends StatelessWidget {
  const _QuickStepsDiagram();

  @override
  Widget build(BuildContext context) {
    final steps = [
      const _StepData(
        number: '1',
        icon: Icons.camera_alt_rounded,
        title: 'Tap "Click a Photo"',
        detail:
            'This opens the screen where you can take or choose a leaf photo.',
        color: Color(0xFFE8F5E9),
      ),
      const _StepData(
        number: '2',
        icon: Icons.photo_camera_back_rounded,
        title: 'Choose Camera or Gallery',
        detail: 'Use Camera for a new photo or Gallery for a saved photo.',
        color: Color(0xFFE3F2FD),
      ),
      const _StepData(
        number: '3',
        icon: Icons.analytics_outlined,
        title: 'Check the photo, then tap Analyze Image',
        detail:
            'You can rotate or retake the photo before sending it for analysis.',
        color: Color(0xFFFFF8E1),
      ),
      const _StepData(
        number: '4',
        icon: Icons.fact_check_rounded,
        title: 'Read the result',
        detail:
            'The app shows the leaf condition, confidence level, and treatment advice.',
        color: Color(0xFFF3E5F5),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 760;

        if (isWide) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var index = 0; index < steps.length; index++) ...[
                    Expanded(child: _StepCard(data: steps[index])),
                    if (index != steps.length - 1)
                      const Padding(
                        padding: EdgeInsets.only(top: 46),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 28,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                  ],
                ],
              ),
              const SizedBox(height: 18),
              const _PermissionTip(),
            ],
          );
        }

        return Column(
          children: [
            for (var index = 0; index < steps.length; index++) ...[
              _StepCard(data: steps[index]),
              if (index != steps.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Icon(
                    Icons.arrow_downward_rounded,
                    size: 28,
                    color: Color(0xFF2E7D32),
                  ),
                ),
            ],
            const SizedBox(height: 6),
            const _PermissionTip(),
          ],
        );
      },
    );
  }
}

class _PermissionTip extends StatelessWidget {
  const _PermissionTip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFA5D6A7)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_open_rounded, color: Color(0xFF2E7D32)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'If the phone asks for camera access, tap Allow. You only need to do this once.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF1B5E20),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepData {
  const _StepData({
    required this.number,
    required this.icon,
    required this.title,
    required this.detail,
    required this.color,
  });

  final String number;
  final IconData icon;
  final String title;
  final String detail;
  final Color color;
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.data});

  final _StepData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2E7D32).withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            child: Text(
              data.number,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 14),
          Icon(data.icon, size: 34, color: const Color(0xFF2E7D32)),
          const SizedBox(height: 12),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.detail,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeButtonGuide extends StatelessWidget {
  const _HomeButtonGuide();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: const [
        _GuideTile(
          icon: Icons.menu,
          title: 'Menu button',
          label: 'Top-left icon',
          detail: 'Opens your profile area, where this help page lives.',
          background: Color(0xFFE8F5E9),
        ),
        _GuideTile(
          icon: Icons.camera_alt,
          title: 'Click a Photo',
          label: 'White button',
          detail: 'Starts a new leaf check with camera or gallery.',
          background: Color(0xFFE3F2FD),
        ),
        _GuideTile(
          icon: Icons.history,
          title: 'Past Predictions',
          label: 'Green button',
          detail: 'Shows your older results so you can check them again.',
          background: Color(0xFFFFF8E1),
        ),
        _GuideTile(
          icon: Icons.cloud_done,
          title: 'AI + Weather Logic',
          label: 'Switch above buttons',
          detail: 'Optional. Turn it on if you want weather data included.',
          background: Color(0xFFF3E5F5),
        ),
      ],
    );
  }
}

class _PhotoTipsDiagram extends StatelessWidget {
  const _PhotoTipsDiagram();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: const [
        _GuideTile(
          icon: Icons.wb_sunny_rounded,
          title: 'Use bright light',
          label: 'Best choice',
          detail:
              'Take the photo where the leaf is easy to see. Avoid dark shade.',
          background: Color(0xFFFFF8E1),
        ),
        _GuideTile(
          icon: Icons.filter_1_rounded,
          title: 'Focus on one leaf',
          label: 'Keep it simple',
          detail: 'Place one clear leaf in the middle so the app sees it well.',
          background: Color(0xFFE8F5E9),
        ),
        _GuideTile(
          icon: Icons.center_focus_strong_rounded,
          title: 'Keep the leaf close',
          label: 'Fill the frame',
          detail:
              'Move the phone closer until the leaf takes most of the photo.',
          background: Color(0xFFE3F2FD),
        ),
        _GuideTile(
          icon: Icons.refresh_rounded,
          title: 'Retake blurry photos',
          label: 'Try again if needed',
          detail:
              'If the picture is shaky, cut off, or dark, take another one.',
          background: Color(0xFFFFEBEE),
        ),
      ],
    );
  }
}

class _GuideTile extends StatelessWidget {
  const _GuideTile({
    required this.icon,
    required this.title,
    required this.label,
    required this.detail,
    required this.background,
  });

  final IconData icon;
  final String title;
  final String label;
  final String detail;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final tileWidth = width > 900 ? 432.0 : double.infinity;

    return Container(
      width: tileWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF2E7D32)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultFlowDiagram extends StatelessWidget {
  const _ResultFlowDiagram();

  @override
  Widget build(BuildContext context) {
    final nodes = [
      const _FlowNodeData(
        icon: Icons.photo_outlined,
        title: 'Your leaf photo',
        detail: 'You confirm the picture on the preview screen.',
        background: Color(0xFFE3F2FD),
      ),
      const _FlowNodeData(
        icon: Icons.psychology_alt_outlined,
        title: 'AI checks the leaf',
        detail: 'Leafcure compares the photo with disease patterns.',
        background: Color(0xFFFFF8E1),
      ),
      const _FlowNodeData(
        icon: Icons.assessment_outlined,
        title: 'Result screen appears',
        detail: 'You see the leaf condition and a confidence bar.',
        background: Color(0xFFE8F5E9),
      ),
      const _FlowNodeData(
        icon: Icons.medical_services_outlined,
        title: 'Read the next step',
        detail: 'If the leaf is sick, the page shows treatment advice.',
        background: Color(0xFFFFEBEE),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 760;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < nodes.length; index++) ...[
                Expanded(child: _FlowNode(data: nodes[index])),
                if (index != nodes.length - 1)
                  const Padding(
                    padding: EdgeInsets.only(top: 46),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 28,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
              ],
            ],
          );
        }

        return Column(
          children: [
            for (var index = 0; index < nodes.length; index++) ...[
              _FlowNode(data: nodes[index]),
              if (index != nodes.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Icon(
                    Icons.arrow_downward_rounded,
                    size: 28,
                    color: Color(0xFF2E7D32),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}

class _FlowNodeData {
  const _FlowNodeData({
    required this.icon,
    required this.title,
    required this.detail,
    required this.background,
  });

  final IconData icon;
  final String title;
  final String detail;
  final Color background;
}

class _FlowNode extends StatelessWidget {
  const _FlowNode({required this.data});

  final _FlowNodeData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: data.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(data.icon, color: const Color(0xFF2E7D32)),
          ),
          const SizedBox(height: 14),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.detail,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpFooter extends StatelessWidget {
  const _HelpFooter({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 20 : 18),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.support_agent, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Simple reminder',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'If the result is unclear, take another photo in brighter light. If you want to see older reports, go back to the home screen and tap Past Predictions.',
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Profile Menu'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1B5E20),
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
