'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "4d058a32641f0888de08d68f470c1d59",
"index.html": "b4c5d6d3703715b9f62675ca6315d61f",
"/": "b4c5d6d3703715b9f62675ca6315d61f",
"homepage.html": "ccebff774aeb92d1708aaf15d613ce3b",
"main.dart.js": "fc70bdb4f0de2e5c620ba8f349a56a0d",
"mobile.html": "898e4d7a9d5ee94bec5adfa2431979fc",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "c8c45dc2d25e4ad129e26bf51c5315b8",
"assets/AssetManifest.json": "1f6f0e9547b14f4c6aaceb5effa88d8a",
"assets/NOTICES": "f79cc78b53573d2cad4ab709483ffc3f",
"assets/FontManifest.json": "202bfb5144bfc3359dc068bcf44cba82",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/fonts/MaterialIcons-Regular.otf": "7e7a6cccddf6d7b20012a548461d5d81",
"assets/assets/music/Mr_Smith-Pequenas_Guitarras.mp3": "50de570341eaaefeb48867fd997df756",
"assets/assets/music/Mr_Smith-Sunday_Solitude.mp3": "5fb1f2fbf4314eb5df35b62706942698",
"assets/assets/music/Mr_Smith-This_Could_Get_Dark.mp3": "308dacb8d3333ae113b1d56416c12fa8",
"assets/assets/music/Mr_Smith-Black_Top.mp3": "b97d0206eb8417fd85257299c8bb2af6",
"assets/assets/music/README.md": "7370dc3b51335ce48fdf8fdf60c23519",
"assets/assets/music/Mr_Smith-Sonorus.mp3": "9353b7bb732002062e2c9107a95f3d2a",
"assets/assets/music/Mr_Smith-Reflector.mp3": "af7101ee88e8d16f8d3a4acd5a68722b",
"assets/assets/music/Mr_Smith-The_Mariachi.mp3": "2639822dd11617822d13482623f1ee18",
"assets/assets/music/Mr_Smith-The_Get_Away.mp3": "fd5783c285c5b443103cec404ef34f74",
"assets/assets/music/Mr_Smith-Azul.mp3": "9463595498dc48b3d3d6805fb7c19dc7",
"assets/assets/Permanent_Marker/PermanentMarker-Regular.ttf": "c863f8028c2505f92540e0ba7c379002",
"assets/assets/images/3x/vertical.png": "7ade8d8e5639890548b58fbca4e5cdae",
"assets/assets/images/3x/circle5.png": "ed162df1a2099976d28b0ff70b015c9c",
"assets/assets/images/3x/cross-end-4.png": "94d62503296377be179d045e02fc0c13",
"assets/assets/images/3x/cross-end-5.png": "ae56a3d6379796a71c89614ff390f271",
"assets/assets/images/3x/circle4.png": "ce3f81eceaef45278b3dd304ca46ece1",
"assets/assets/images/3x/cross-end-1.png": "562ae10d9edf95fdfd82684356726d32",
"assets/assets/images/3x/circle.png": "45bd064cfb6d998a927b0f2e62a2ac2d",
"assets/assets/images/3x/circle1.png": "d1d60d9224fd51a0704fd19df29f4f72",
"assets/assets/images/3x/cross-end-2.png": "285ba8cfc0cd971818bacd8ea9692331",
"assets/assets/images/3x/circle3.png": "e2100bb61882a176b520af9401cfd361",
"assets/assets/images/3x/horizontal.png": "df18b2454944958553caece40d9ffc4b",
"assets/assets/images/3x/background.jpg": "ac1ff67228fafa2673210480cd88bde7",
"assets/assets/images/3x/circle2.png": "5c00d2a74fa92007ea2ab83bc675298b",
"assets/assets/images/3x/cross-end-3.png": "03e339bd089717dd74ed98c0a1c20a87",
"assets/assets/images/3x/cross-start-1.png": "e0695eb43aa61f70b7b47fe9f100b898",
"assets/assets/images/3x/bar1.png": "8dd59715f498ad343e5c751a99ffc7a0",
"assets/assets/images/3x/cross-start-2.png": "563279f8aabb4bdaa01466ef3213fd46",
"assets/assets/images/3x/cross-end.png": "8da9e7e1e9f9c72653e5ad216ef9e8c6",
"assets/assets/images/3x/cross-start-3.png": "fa9a8c7b1493d7d3d8ce027ab25bf095",
"assets/assets/images/3x/cross.png": "a3ddce39cac037e85acf57fe1d375e8f",
"assets/assets/images/3x/cross-start-4.png": "3aeb2fbb695bfe64d7440faa1d802104",
"assets/assets/images/3x/cross-start-5.png": "ee383c3555430d2a5aca3d3929d6464b",
"assets/assets/images/3x/cross-start.png": "c81fc2d75085e6886131c4fff8184750",
"assets/assets/images/vertical.png": "6a6a0b77f8bc397e38e5af0023a4faeb",
"assets/assets/images/circle5.png": "d3e1e05479daeff48393864bd7d4f325",
"assets/assets/images/cross-end-4.png": "b9792b7cee48a041cf627163c4e62589",
"assets/assets/images/cross-end-5.png": "f662429ea4637802377319765a0b67a3",
"assets/assets/images/circle4.png": "665add9d1fb70a6c588c82130783954b",
"assets/assets/images/cross-end-1.png": "0022ceeb104c74364d76e364178e9bc6",
"assets/assets/images/circle.png": "c8f1270b88efaf82a10949255aca5fbb",
"assets/assets/images/circle1.png": "a03db108e1e52944a9123ca12567f9c4",
"assets/assets/images/cross-end-2.png": "1d48367afb86d8dc993feed715c366d8",
"assets/assets/images/circle3.png": "354204a4f7bcea4582a9aef5b9762ce9",
"assets/assets/images/horizontal.png": "3cb5f075a49419c877eb5df8283c8a94",
"assets/assets/images/background.jpg": "68fc0b6a300f9bd33b186c39a4add740",
"assets/assets/images/circle2.png": "82bfdd0309217c2d19fdfc0f125adf65",
"assets/assets/images/cross-end-3.png": "c4c7ea35fc84a766c80cade201fafdd1",
"assets/assets/images/cross-start-1.png": "eac554eea7aa257abd45e6fa374d4cdd",
"assets/assets/images/bar1.png": "37bb62be2b41bf99ee82f535486f1768",
"assets/assets/images/cross-start-2.png": "16fc933da40042cb5f16b312456289ed",
"assets/assets/images/cross-end.png": "06bcd60f98e4b68692fea1bc1d3caa2a",
"assets/assets/images/cross-start-3.png": "90abdfe2e39c0796edeb77a85874c2d3",
"assets/assets/images/confetti.gif": "5f28afeca72830c7c795cad8e602e90f",
"assets/assets/images/cross.png": "8b22093f4f706d6aa4378b040a75084b",
"assets/assets/images/cross-start-4.png": "962b9e999f1e10b1b6982f7b6d81d8b0",
"assets/assets/images/cross-start-5.png": "f646ff0e1f0ef5d4aefa6abbb6eba48c",
"assets/assets/images/cross-start.png": "e7e07ba24178b530d08ae7dd678f3e92",
"assets/assets/images/2x/vertical.png": "6dc77e3bd935e9dcb157912a03cc7b63",
"assets/assets/images/2x/circle5.png": "3e320bd1315f1521ee5e585b2e6d8c18",
"assets/assets/images/2x/cross-end-4.png": "288889a3921f2c86ac8579103c7760dc",
"assets/assets/images/2x/cross-end-5.png": "e68c171ebf660ceab56c0fae779175ad",
"assets/assets/images/2x/circle4.png": "d57bc975c2045d50bee297b8e84259bf",
"assets/assets/images/2x/cross-end-1.png": "71bce6f61970e0ea3f77cd5f9f8bd8de",
"assets/assets/images/2x/circle.png": "527e2d76986c4656b861a6cb0b026da6",
"assets/assets/images/2x/circle1.png": "f2f62d758625dda1b153647f9564d03a",
"assets/assets/images/2x/cross-end-2.png": "da44e55bac5ecf1a72c6b619d13a3f25",
"assets/assets/images/2x/circle3.png": "bdd64b298ff439e160a03959430acae2",
"assets/assets/images/2x/horizontal.png": "4cd264b2eced969dbe1044d2692c461b",
"assets/assets/images/2x/background.jpg": "04512649fdfdaabc8a7f33e4085c2486",
"assets/assets/images/2x/circle2.png": "3b1808bd60b91df4f0f6e963c75ce040",
"assets/assets/images/2x/cross-end-3.png": "c9293aafb8e410cd01a22ae0c2b4dff6",
"assets/assets/images/2x/cross-start-1.png": "3f5701c8ef02e84221a0bb24ef933079",
"assets/assets/images/2x/bar1.png": "b1425eeb8a4a8c16a9ed42ca61ae3ac9",
"assets/assets/images/2x/cross-start-2.png": "75f6335be4ddea3e8623d0e4ae35e420",
"assets/assets/images/2x/cross-end.png": "977f6aa252e6b32bc1ce7934aeaedc82",
"assets/assets/images/2x/cross-start-3.png": "0338a1a412988196ad847eed3de8a400",
"assets/assets/images/2x/cross.png": "52184e7d748853317076b18692fc5e50",
"assets/assets/images/2x/cross-start-4.png": "d648ef6bad1abbcfaf05960968fba54b",
"assets/assets/images/2x/cross-start-5.png": "81c58f4cc03d99b672444a9e068ecf33",
"assets/assets/images/2x/cross-start.png": "df32a9e0581cf2855ae173c635a7dc96",
"assets/assets/images/3.5x/vertical.png": "ce8d4462f79ce98fc4db460bf2874e9e",
"assets/assets/images/3.5x/circle5.png": "99412abbc4f574792c6ec32a1131819c",
"assets/assets/images/3.5x/cross-end-4.png": "31208f6c6b5b14282a581ade6c8db2a8",
"assets/assets/images/3.5x/cross-end-5.png": "e5164f65c3bebc004732c53be6fea550",
"assets/assets/images/3.5x/circle4.png": "1ae9ed76efb4fc5f6e3d98ffb2785dc0",
"assets/assets/images/3.5x/cross-end-1.png": "0e08a4853115180550677d728382bde1",
"assets/assets/images/3.5x/circle.png": "1cb0ccc499cace3b384cad9995e53988",
"assets/assets/images/3.5x/circle1.png": "b4d5887882d6f573888672ca104e321b",
"assets/assets/images/3.5x/cross-end-2.png": "61ebc726d4710e531ecb342bc7bfdca1",
"assets/assets/images/3.5x/circle3.png": "6b576bf90f964515bb44c345f30a9b9a",
"assets/assets/images/3.5x/horizontal.png": "0654c3018197ecb81c6fd39e07b2fd23",
"assets/assets/images/3.5x/background.jpg": "8ce50545019352221c8e276f0f7ce5ef",
"assets/assets/images/3.5x/circle2.png": "276a115a05bc5417c1354a987287ceef",
"assets/assets/images/3.5x/cross-end-3.png": "d02555f4d5cdf179cbf92984c33ac466",
"assets/assets/images/3.5x/cross-start-1.png": "02119a9fa8936baa709c2468cd7eba42",
"assets/assets/images/3.5x/bar1.png": "a9d85980d321dd56dcc977275362e802",
"assets/assets/images/3.5x/cross-start-2.png": "ca044330cc1d8b467d416d4b367a4fa9",
"assets/assets/images/3.5x/cross-end.png": "4e21e68e75959724b678a8f58760d448",
"assets/assets/images/3.5x/cross-start-3.png": "e470ded3935d2ddb0ef5b49213f2b9e0",
"assets/assets/images/3.5x/cross-start-4.png": "3aebb42c63e6c0da8daafb0b43a90743",
"assets/assets/images/3.5x/cross-start-5.png": "5c68c9c3ad26249e35894d6e904e6f13",
"assets/assets/images/3.5x/cross-start.png": "9508a527bafdb7ebc5734f705f671199",
"assets/assets/sfx/kss1.mp3": "fd0664b62bb9205c1ba6868d2d185897",
"assets/assets/sfx/spsh1.mp3": "2e1354f39a5988afabb2fdd27cba63e1",
"assets/assets/sfx/sh1.mp3": "f695db540ae0ea850ecbb341a825a47b",
"assets/assets/sfx/hh1.mp3": "fab21158730b078ce90568ce2055db07",
"assets/assets/sfx/p1.mp3": "ad28c0d29ac9e8adf9a91a46bfbfac82",
"assets/assets/sfx/sh2.mp3": "e3212b9a7d1456ecda26fdc263ddd3d0",
"assets/assets/sfx/hh2.mp3": "4d39e7365b89c74db536c32dfe35580b",
"assets/assets/sfx/kch1.mp3": "a832ed0c8798b4ec95c929a5b0cabd3f",
"assets/assets/sfx/oo1.mp3": "94b9149911d0f2de8f3880c524b93683",
"assets/assets/sfx/lalala1.mp3": "b0b85bf59814b014ff48d6d79275ecfd",
"assets/assets/sfx/p2.mp3": "ab829255f1ef20fbd4340a7c9e5157ad",
"assets/assets/sfx/hash3.mp3": "38aad045fbbf951bf5e4ca882b56245e",
"assets/assets/sfx/hash2.mp3": "d26cb7676c3c0d13a78799b3ccac4103",
"assets/assets/sfx/wssh1.mp3": "cf92e8d8483097569e3278c82ac9f871",
"assets/assets/sfx/dsht1.mp3": "c99ece72f0957a9eaf52ade494465946",
"assets/assets/sfx/hash1.mp3": "f444469cd7a5a27062580ecd2b481770",
"assets/assets/sfx/wssh2.mp3": "255c455d9692c697400696cbb28511cc",
"assets/assets/sfx/README.md": "5bfe8da38428ed780fe52a24eef25670",
"assets/assets/sfx/yay1.mp3": "8d3b940e33ccfec612d06a41ae616f71",
"assets/assets/sfx/k2.mp3": "8ec44723c33a1e41f9a96d6bbecde6b9",
"assets/assets/sfx/k1.mp3": "37ffb6f8c0435298b0a02e4e302e5b1f",
"assets/assets/sfx/haw1.mp3": "00db66b69283acb63a887136dfe7a73c",
"assets/assets/sfx/ehehee1.mp3": "52f5042736fa3f4d4198b97fe50ce7f3",
"assets/assets/sfx/ws1.mp3": "5cfa8fda1ee940e65a19391ddef4d477",
"assets/assets/sfx/wehee1.mp3": "5a986231104c9f084104e5ee1c564bc4",
"privacy.html": "dd73b55298dd5858d831d95fa429ba4e"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
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
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
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
