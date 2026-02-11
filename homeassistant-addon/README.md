# Windows Notification Bridge Add-on

This Home Assistant add-on enables bidirectional communication between Home Assistant and a Windows machine for notifications and system events.

## Features

- **Send Notifications to Windows**: Toast notifications, audio alerts, and emails
- **Receive Windows Events**: Email arrivals, system restarts, and custom events
- **MQTT Communication**: Reliable message delivery with QoS
- **Future-Ready**: Abstraction layer for easy migration to REST API

## Installation

1. Add this repository to your Home Assistant add-on store
2. Install the "Windows Notification Bridge" add-on
3. Configure the add-on (see Configuration below)
4. Start the add-on

## Configuration

### Options

| Option | Required | Default | Description |
|--------|----------|---------|-------------|
| `mqtt_broker` | Yes | `core-mosquitto` | MQTT broker hostname/IP |
| `mqtt_port` | Yes | `1883` | MQTT broker port |
| `mqtt_username` | No | `""` | MQTT username (if auth enabled) |
| `mqtt_password` | No | `""` | MQTT password (if auth enabled) |
| `communication_mode` | Yes | `mqtt` | Protocol to use (mqtt or rest_api) |
| `windows_service_ip` | No | `""` | Windows service IP for REST API |
| `log_level` | Yes | `info` | Logging level |

### Example Configuration

```yaml
mqtt_broker: core-mosquitto
mqtt_port: 1883
mqtt_username: mqtt_user
mqtt_password: my_secure_password
communication_mode: mqtt
log_level: info
```

## Usage

### Sending Notifications to Windows

Use the MQTT publish service in Home Assistant:

```yaml
service: mqtt.publish
data:
  topic: "homeassistant/notifications/to_windows/notification"
  payload: |
    {
      "type": "notification",
      "priority": "high",
      "payload": {
        "action": "show_notification",
        "data": {
          "title": "Alert",
          "message": "Something happened!"
        }
      }
    }
```

### Receiving Windows Events

Windows events are published to:
```
homeassistant/notifications/from_windows/{event_type}
```

Create automations that listen to these topics:

```yaml
automation:
  - alias: "React to Windows Event"
    trigger:
      - platform: mqtt
        topic: "homeassistant/notifications/from_windows/email"
    action:
      - service: notify.mobile_app
        data:
          message: "New email on Windows PC"
```

## MQTT Topics

- **To Windows**: `homeassistant/notifications/to_windows/{type}`
- **From Windows**: `homeassistant/notifications/from_windows/{type}`
- **Status**: `homeassistant/notifications/status`

## Message Format

All messages use a standardized JSON format:

```json
{
  "id": "unique-id",
  "timestamp": "2026-02-11T12:00:00Z",
  "type": "notification|event|command|status",
  "priority": "low|normal|high|critical",
  "source": "homeassistant|windows",
  "payload": {
    "action": "action_name",
    "data": {
      // Action-specific data
    }
  }
}
```

## Supported Actions

### show_notification
Display a Windows toast notification:
```json
{
  "action": "show_notification",
  "data": {
    "title": "Alert Title",
    "message": "Message text",
    "duration": 5000
  }
}
```

### play_audio
Play an audio file:
```json
{
  "action": "play_audio",
  "data": {
    "audio_file": "alert.wav",
    "volume": 80
  }
}
```

### send_email
Send an email via SMTP:
```json
{
  "action": "send_email",
  "data": {
    "to": "recipient@example.com",
    "subject": "Alert Subject",
    "body": "Email body text"
  }
}
```

## Troubleshooting

### Add-on won't start
- Check MQTT broker is running
- Verify MQTT credentials are correct
- Check logs for detailed error messages

### Not receiving Windows events
- Ensure Windows service is running
- Check Windows service is configured with correct MQTT broker address
- Verify MQTT topics in Windows service match add-on topics

### Messages not being delivered
- Check MQTT broker logs
- Verify QoS settings
- Ensure topic names are correct

## Support

For issues and questions:
- GitHub Issues: https://github.com/hamlinda/ha-windows-notification-bridge/issues
- Home Assistant Community Forum

## License

MIT License - See LICENSE file for details