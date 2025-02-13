'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "6ff384565811cc7b225e0c1cc9501d35",
"version.json": "802792a9cfa68119e6697aebffa8522f",
"index.html": "6bd188ec7a9acb1a23e05cdadde7f75c",
"/": "6bd188ec7a9acb1a23e05cdadde7f75c",
"main.dart.js": "589abc5bd3293e38d0cac3ea53b41bd6",
"404.html": "f72e3380ef6f7ed7339b2e3d9b4eb337",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"favicon.png": "71319db4b17d8bcda0a43eec4181944a",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "8545178f270fb55a77970f2082329154",
".git/config": "76bb3fff264f07ffec80f41dd72e2690",
".git/objects/92/17413155c6d24e6a13ac13fa1f6493e09e0f49": "138cd3827980c6d455d1993f84462caa",
".git/objects/3b/b0860a0981211a1ab11fced3e6dad7e9bc1834": "3f00fdcdb1bb283f5ce8fd548f00af7b",
".git/objects/9e/cef67b92288750f1e76a5ecc0a58ffcaad98e8": "03347c927a3a20ce80abdd65a3766553",
".git/objects/04/1d833c5bc20f9d7d677287b747aec1a4425635": "88195d7f6a0275e0021e906a56dcec5c",
".git/objects/69/3521f65335dd8c9eccd862e6d1f751698cec04": "a74c88aea96874204710c5fceb31e084",
".git/objects/56/6d4e85f37019c0039ced3b719ec617762b9544": "6d1c2a681793c2bde685ebc6374a5037",
".git/objects/0b/4e627c9b24b9f1384f488618ece634e0f55106": "945404d3233e6986e238c5bda2ece94d",
".git/objects/93/defec806aa14e4a6201c028fd9d6d540be21d2": "455be35079a92234d40b26ca350b1149",
".git/objects/34/b16bd0f93e550e8cbffc6f2b4c7b88986e2c91": "e57694810c586699d774232a6f1cf265",
".git/objects/9d/95f40f96dc3518e59b95f76c6fdb098d1a82b4": "c08c82c2a6636fca103adcd5dfdc7ae3",
".git/objects/9d/373cee25650f675ff0d3472b8dbf3c4fb6c4d6": "5df6f3d5b4bf911819c800b4335fc3db",
".git/objects/b5/ac6606c382802c3c76d3cbae12122d123ea99f": "415bee3412037970d86076d9cfbc3484",
".git/objects/b2/27b6fc448d5a485f82c4879eef038fbf208912": "53a142ea1cb3727194e257135124a8ae",
".git/objects/ad/4c0ba9842f4de544316a62269732d33f652961": "d2648c4f7ac6a01d24dedabffef3980b",
".git/objects/df/a3cd0d30dab54e4447d1ee80ec1867ca85ede1": "cb4e0ee38d8ae09173754b6936cd0353",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/bc/76097b6a1ae3ca9b365bbd61ef80540bc21ae6": "de0a1ec05bdf2bca63c7344ac657013b",
".git/objects/ab/b9d558ad7a0283bf9e5b4aae3dc00708c72d18": "e783cb19c03e956ba646ccb0b56f777d",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/c7/7663172ca915a99a594ca17d06f527db05657d": "6335b074b18eb4ebe51f3a2c609a6ecc",
".git/objects/c9/c6b1a08036669f2ee3c7746063c09ce14644ff": "32f097b0e000fccfa5d1a6b2ae25af96",
".git/objects/c9/1598987b8a5cf876f4223152f22aa7a4367738": "0e3c548ccf4899f5b8cbee1fa04b3487",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f2/928ecdb8c834ab5c29ec915ef9c664f7a1a4e1": "4b6ea6b93d1311cd7a3542eb50f030be",
".git/objects/cf/fafcf633c1f4e3ff1d80bd36ed0cc9da17c202": "7c81149e86211b3b6054611faf7a87fa",
".git/objects/ca/056cb89f6ebbf622b458087c5a803230069d8a": "9abb034d7264974bb9383d788741280d",
".git/objects/e4/c16f0c284bc5549128b6ba0536fe0c8ba3716f": "556c2ad6359d568447bb7b5670d81f1a",
".git/objects/fe/3618ac44ba39ae4f48c33907be029a57050b87": "517aa29620d6dfdaccd4f8de54e8341c",
".git/objects/c8/38d0e6ad9c3d5d924f31a3d7e82b1a03d61894": "535d279a69bf48e1998930a07a4c1351",
".git/objects/fb/bf27bbe0848cfba4d7d94f69140019b2013f84": "74f8afd5a4d2b42a29d55b03152ac9d1",
".git/objects/c6/06caa16378473a4bb9e8807b6f43e69acf30ad": "ed187e1b169337b5fbbce611844136c6",
".git/objects/ec/a36a37a826f3932106a505d6a2707a1ebc453f": "ba6040a813ac78cd0b87d423a52aa08a",
".git/objects/ec/361605e9e785c47c62dd46a67f9c352731226b": "d1eafaea77b21719d7c450bcf18236d6",
".git/objects/20/365a2aabfc11c52d5b95fab8c16b9d73e91348": "45325354692c55e2631fb8779ebfa546",
".git/objects/27/a297abdda86a3cbc2d04f0036af1e62ae008c7": "51d74211c02d96c368704b99da4022d5",
".git/objects/45/eabe331a753aff70ed83270e697a15a056af4d": "42851ddcbb8583f81e669c74850ab011",
".git/objects/1f/45b5bcaac804825befd9117111e700e8fcb782": "7a9d811fd6ce7c7455466153561fb479",
".git/objects/73/7f149c855c9ccd61a5e24ce64783eaf921c709": "1d813736c393435d016c1bfc46a6a3a6",
".git/objects/74/fce7ebedfd2c5672db4da95384e96405f8ab30": "a254dbd92c883ac02f36a9e37a114f9e",
".git/objects/1a/da840f0eb5f13b4646698b8226512ce864e848": "07220c9f4d6295970dfd1eec03f89b9d",
".git/objects/17/31c62a70d3997c4a596c28fbb78714d7c9f633": "fc304f7b96fdf0931fc6400f2e1aca80",
".git/objects/8f/11c5c44819fd0d17dcb10a945e88a06870b39f": "d7c980f388d5edbb3ba540c99c0c2b05",
".git/objects/4d/cd7d3f0d5b993503d408bb4ccdac31c2a46818": "7ce39a31d7cc12cac87aee5ae2cb7c41",
".git/objects/75/ba47cba1342e69d2b34fbab6bf0a845fd33ad4": "d80af16ac102122b92ac640616b80e58",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/07/a27d24396ef23d816f1d519ead3c289c185c65": "f307cc73918c69056368ef493568c77f",
".git/objects/38/45f24f9209f2a65d5e165738381914a4a8fb5f": "b217575935cd43bd2b582d71753c54b2",
".git/objects/00/18f535545d5c93c727910d29fbaf4984b82599": "20d404aac5e2407dd1a288061657d43a",
".git/objects/65/2d4b70526d6761835160d1617a8528b783ee67": "9afb221233c0f4199aa7b3d420400ade",
".git/objects/62/1b773ec911de13affb4ee2a9ca8e08131682c9": "35e7485bcc8ed763790ffa6a16a4e60d",
".git/objects/98/3cfa514de07aba6547a26985e1157eebb6d22c": "a2e2379d9b093727def3942ba03ee295",
".git/objects/5e/9ef392d35bd92565da1f3be1e3f26b7f97f266": "9e2305c42a87df3f53d89e449118b21b",
".git/objects/5e/6117f53a67040470a9654cc57873db994afccf": "b3a66ccdd8dec29b0c67ed3aac40ba1c",
".git/objects/6d/5f0fdc7ccbdf7d01fc607eb818f81a0165627e": "2b2403c52cb620129b4bbc62f12abd57",
".git/objects/6d/3839c8543caacac976abf2c89d9856148792e6": "24895ff6a68d03625433b0e083b49292",
".git/objects/06/5a156ad876ae75d08bca0aabc8c1e01f285abb": "1338ac20d12542d14345378e2fe2be26",
".git/objects/6c/4ad085e88742e2d2b93b0f52d4a7522ca86ad0": "288b57c9ec4d84b6ffeceb0911fb113d",
".git/objects/6c/92da21b1c5fda0a7bfa6fcc75f6a64f81be117": "f59e79b807c44a3378bb605ee538c4a9",
".git/objects/99/1c8979d168007b04f944492bb3d263764319ef": "c02590c7b7e8b8eada25f6c107e7ead2",
".git/objects/97/fee63d6d5812b771f7ba6b58836bf63f69c0d7": "4a5555c565285fe299fa534dfd97b9f8",
".git/objects/97/8a4d89de1d1e20408919ec3f54f9bba275d66f": "dbaa9c6711faa6123b43ef2573bc1457",
".git/objects/63/6931bcaa0ab4c3ff63c22d54be8c048340177b": "8cc9c6021cbd64a862e0e47758619fb7",
".git/objects/0f/68cacb53a4a5204c354b7c789d5e3d06f531c6": "ec94421b11b9b6f3d9aecc7807593250",
".git/objects/0a/e80005aea6d2d1343787852f150adf2217a752": "4bf6aa0e8ac4fe392cbb0df7a3857e77",
".git/objects/90/f5d5d928a7ff952cf53e4b88206756e18650ee": "d8c86ae505bf0df2af61b8b43a5dd5c1",
".git/objects/d3/1de1d4830cb726b04d1b0c9f47a9ba651dbdef": "d72d55548356f33ad9a853383f335b47",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/ba/5317db6066f0f7cfe94eec93dc654820ce848c": "9b7629bf1180798cf66df4142eb19a4e",
".git/objects/b1/5ad935a6a00c2433c7fadad53602c1d0324365": "8f96f41fe1f2721c9e97d75caa004410",
".git/objects/b1/afd5429fbe3cc7a88b89f454006eb7b018849a": "e4c2e016668208ba57348269fcb46d7b",
".git/objects/b6/edb31254279ae192f63b113840b5c16d2e4f7c": "3c8d459fd3c5952643074d49ea84edec",
".git/objects/d5/80ce749ea55b12b92f5db7747290419c975070": "8b0329dbc6565154a5434e6a0f898fdb",
".git/objects/d2/9e1fd41da878688e4dc5f035cd2914d703386d": "e03ce2153874d63da55fe5ebec24bf06",
".git/objects/aa/9aa95a850456441f60ec474021276482efa8b6": "e574fc01ab1d903682ceffd6e78e9eec",
".git/objects/af/31ef4d98c006d9ada76f407195ad20570cc8e1": "a9d4d1360c77d67b4bb052383a3bdfd9",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/de/d2d1d7bee667d5ec4bc9162eb79af3ce997b9d": "9551e2debf7a4965e8cbdfaaec054e75",
".git/objects/b0/0eae0c4ff2e1dec3b36249b1a83ff4e7dcec53": "d4eddf8a6f70a2803778a2c932eec594",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/c3/e81f822689e3b8c05262eec63e4769e0dea74c": "8c6432dca0ea3fdc0d215dcc05d00a66",
".git/objects/c4/4fe0404cdbb2878900bd48c059caafa2aebc1f": "dd84f7f0c45d45308bd4c400bde8b6d5",
".git/objects/e7/c531fe86cfc4e64c5dff04cde7fa8d13bcce0d": "d1d6509b0238c36af872dcc7ddeb688d",
".git/objects/e7/c4334cdc5cd523efa51d3871ff0b83d2fb60df": "a3a630f4df2f94e232e38f732507c109",
".git/objects/cb/9fada600d5bc92a2fd43134227988143fb22ed": "361538d21cd1666ea8e2879040d10f56",
".git/objects/ce/aa6381478b4158f1c917c4df6ffe374355ab74": "ce2479f67df51bc62dd58676d658780b",
".git/objects/2d/0471ef9f12c9641643e7de6ebf25c440812b41": "d92fd35a211d5e9c566342a07818e99e",
".git/objects/2d/fcdbe9f2df0332cee24295b9c0a4cdbf2478b7": "b40637ed7a305a7a7296f4f96b139cc1",
".git/objects/41/5c059c8094b888b0159fdedfd4e3cb08a8028e": "86914685ccd40e82a7fe5b70459fb9f7",
".git/objects/48/926622f264024a9069979a70efebbfb70de1c7": "3f2ef711dc3a377d926a99210b59bd40",
".git/objects/23/67660e359dbc7f440282c59b904d9698f74264": "e4b68e7e2195403e872f6c957bd6f21e",
".git/objects/4f/346c3e43f95e778d7cef3cb6ceede9cd2bf1c8": "99981890f1649c8ef95c28d9e5a27d4e",
".git/objects/8c/99266130a89547b4344f47e08aacad473b14e0": "41375232ceba14f47b99f9d83708cb79",
".git/objects/85/6a39233232244ba2497a38bdd13b2f0db12c82": "eef4643a9711cce94f555ae60fecd388",
".git/objects/71/465f82dd7409e250b01b444a872265cb54709a": "43ae567d165dc2a071bc14b4427a5d7e",
".git/objects/76/0ff6af40e4946e3b2734c0e69a6e186ab4d8f4": "009b8f1268bb6c384d233bd88764e6f8",
".git/objects/40/f1694ba4c97cdfaaa99a6459feab9a24614586": "aca2ed34561ba1ba8fc7d7674cd50113",
".git/objects/2b/853bbd69f8706a09fc638e1da7904e0b11c74c": "51965d6d4fd88a7f6311530d67fc9321",
".git/objects/7f/70a4f579db488d391bb4961c1709bcd9ac34cb": "c2b95065648a615766ab63dc472ba6be",
".git/objects/8e/9d9785fc6f0f8707800fa29dde58d7fc612c7d": "98a6053c761fcc0160514b31bb4256ad",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "d8ce6396d65f51cba7a6849f2d783d26",
".git/logs/refs/heads/main": "ced0179a38ba60ac2d01383abfe0a185",
".git/logs/refs/remotes/origin/main": "fb34ad7fc16412a685c5cd053274bf09",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/refs/heads/main": "6db26138aac0ca98a5c75d580ac5a09a",
".git/refs/remotes/origin/main": "6db26138aac0ca98a5c75d580ac5a09a",
".git/index": "e35efd27e69e715d65df24199b75f482",
".git/COMMIT_EDITMSG": "6535448f3722376e01f0574fc396e363",
"assets/AssetManifest.json": "6dc892ee9ff433fc6a386252afeb2128",
"assets/NOTICES": "af1aacd5d1d7b12c51d7f1001a90abed",
"assets/FontManifest.json": "3c6f2aec284ba6e927fd5e00fb6c4257",
"assets/AssetManifest.bin.json": "17038ed155a3a47e241b89272378f000",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b93248a553f9e8bc17f1065929d5934b",
"assets/packages/iconsax/lib/assets/fonts/iconsax.ttf": "071d77779414a409552e0584dcbfd03d",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "5214ac736fc9e3392bb047a099efd983",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/assets/images/logo.jpg": "eb24d1bae0613922ae46a34e47b5e007",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
