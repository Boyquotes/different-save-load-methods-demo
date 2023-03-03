# Different save load methods demo

For Godot 4, it compares four different save methods. Note that these methods
are not mutually exclusive, you can mix and match them. But this demo assumes
that you're using them all separately.

## Comparison of different saving and loading methods

| Type of saving and loading | Text | Binary | Standard format | Stores all data types |
| --- | --- | --- | --- | --- |
| JSON | ✅ | 🟥 | ✅ | 🟥 |
| ConfigFile | ✅ | 🟥 | ✅ | ✅ |
| Custom resource | ✅ | ✅ | 🟥 | ✅ |
| PackedScene | ✅ | ✅ | 🟥 | ✅ |

## Additional notes
### Custom resource
- Needs to have the variables that you want to save as @export variables.
- The `_init()` (the one that is used when you call `new()`) function needs to have default parameters.
### PackedScene
- Takes the longest to save and load since it's saving everything.
- Not compatible with games that are updated.

## Credits
- Icon by [ColourCreatype](https://freeicons.io/profile/5790) on [freeicons.io](https://freeicons.io)
