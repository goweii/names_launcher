<div align="center">
  <h1 align="center" style="font-size: 50px;">✨ Names Launcher ✨</h1>
  <p align="center">
  A command-line tool that simplifies the task of updating your Flutter app's launcher name. Full flexibility allows you to only update the launcher name for specific platforms as needed.
 </p>
</div>

### **Platform Support**

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: | :-: | :---: | :-----: |
|   ✔️    | ✔️  |  ✔️   | ✔️  |  ✔️   |   ✔️    |

## Guide

### 1. Setup the config file

Add your Names Launcher configuration to your `pubspec.yaml` or create a new config file called `names_launcher.yaml`.

#### Add config to `pubspec.yaml` or create a separate `names_launcher.yaml`

```yaml
names_launcher:
  name: "Your App Name"
  platforms:
    android:
      enable: true
    ios:
      enable: true
```

Or set localized app names as below

```yaml
names_launcher:
  name:
    default: "Your App Name"
    zh: "中文名"
  platforms:
    android:
      enable: true
    ios:
      enable: true
```

### 2. Run the package

After setting up the configuration, all that is left to do is run the package:

```sh
flutter pub get
dart run names_launcher:change
```

If you name your configuration file something other than `names_launcher.yaml` or `pubspec.yaml` you will need to specify the name of the file when running the package.

```sh
flutter pub get
dart run names_launcher:change --path <your config file name here>
```

NOTE: If you are not using the existing `pubspec.yaml` your config file must still be located in the same directory as it.

If you encounter any issues [please report them here](https://github.com/goweii/names_launcher/issues).

In the above configuration, the package is setup to change the existing launcher names in both the Android and iOS project.

---

## Attributes

Shown below is the full list of attributes which you can specify within your Names Launcher configuration.

| Names Launcher Option | Type          | Default | Description                               |
| --------------------- | ------------- | ------- | ----------------------------------------- |
| `name`                | String/Object | `null`  | The launcher name or localized names      |
| `platforms`           | Object        | `null`  | Use for specific platform to change names |

---

| Platforms Option | Type   | Default | Description                       |
| ---------------- | ------ | ------- | --------------------------------- |
| `android`        | Object | `null`  | Use for specific android platform |
| `ios`            | Object | `null`  | Use for specific android platform |
| `macos`          | Object | `null`  | Use for specific android platform |
| `windows`        | Object | `null`  | Use for specific android platform |
| `web`            | Object | `null`  | Use for specific android platform |
| `linux`          | Object | `null`  | Use for specific android platform |

| Android Option | Type          | Default | Description                          |
| -------------- | ------------- | ------- | ------------------------------------ |
| `enable`       | Boolean       | `false` | Use for enable Android platform      |
| `name`         | String/Object | `null`  | The launcher name or localized names |

| iOS Option     | Type          | Default | Description                          |
| -------------- | ------------- | ------- | ------------------------------------ |
| `enable`       | Boolean       | `false` | Use for enable iOS platform          |
| `name`         | String/Object | `null`  | The launcher name or localized names |

| MacOS Option   | Type          | Default | Description                          |
| -------------- | ------------- | ------- | ------------------------------------ |
| `enable`       | Boolean       | `false` | Use for enable MacOS platform        |
| `name`         | String/Object | `null`  | The launcher name or localized names |

| Windows Option | Type          | Default | Description                          |
| -------------- | ------------- | ------- | ------------------------------------ |
| `enable`       | Boolean       | `false` | Use for enable Windows platform      |
| `name`         | String/Object | `null`  | The launcher name or localized names |

| Linux Option   | Type          | Default | Description                          |
| -------------- | ------------- | ------- | ------------------------------------ |
| `enable`       | Boolean       | `false` | Use for enable Linux platform        |
| `name`         | String/Object | `null`  | The launcher name or localized names |

| Web Option     | Type          | Default | Description                          |
| -------------- | ------------- | ------- | ------------------------------------ |
| `enable`       | Boolean       | `false` | Use for enable Web platform          |
| `name`         | String/Object | `null`  | The launcher name or localized names |

---

## Example

```yaml
names_launcher:
  name:
    default: "Your App Default Name"
    zh: "应用中文名"
  platforms:
    android:
      enable: true
    ios:
      enable: true
    web:
      enable: true
    macos:
      enable: false
    windows:
      enable: false
    linux:
      enable: false
```