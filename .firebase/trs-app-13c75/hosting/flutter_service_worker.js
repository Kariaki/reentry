'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "5ce2b08e6d64f8e9b6789e664e3464a5",
"assets/AssetManifest.bin.json": "2c31ee8ea5388d34fa389139a5bd0edd",
"assets/AssetManifest.json": "8fe0ec6f434e82bd5bf3c8e101c044b0",
"assets/assets/font/Inter_18pt-Bold.ttf": "7ef6f6d68c7fedc103180f2254985e8c",
"assets/assets/font/Inter_28pt-Medium.ttf": "4bf75147230e93108702b004fdee55df",
"assets/assets/font/Inter_28pt-Regular.ttf": "fc20e0880f7747bb39b85f2a0722b371",
"assets/assets/images/angry.png": "be802e8330d05c11cbb8a018f6cf35c0",
"assets/assets/images/anxiety.png": "f9987cd2100ab7d6672c9572f47d8282",
"assets/assets/images/calender.png": "53ddf77d091a98325916d9d604bf20ef",
"assets/assets/images/citiImg.png": "a29abf6971b2fc3a80ae5c8a7368ef54",
"assets/assets/images/confusion.png": "d435243cc27e639df58c0cc6448fadd9",
"assets/assets/images/daily_action.png": "1c7e9c2a3574a797ef607e88b593f3ca",
"assets/assets/images/fear.png": "85363f3d71deb26100e55e4e6e46dc3f",
"assets/assets/images/get_mentor.png": "8be418929fe8389925d6c977fbd5c37e",
"assets/assets/images/goals.png": "fadd98822549953826e47fcfda4ced46",
"assets/assets/images/growth.png": "d1807ebb1eb43c0e7abf6f6de83f44a7",
"assets/assets/images/happy.png": "80a0f8ee3b7ba9b646f14e8755be5705",
"assets/assets/images/loved.png": "2725a76b4e23a6f60665a7c6940fb2e4",
"assets/assets/images/People.png": "8e4d1de8bf79783f923ccda63773a976",
"assets/assets/images/sad.png": "10f2a0385919d074b9b2d8372cf50bdf",
"assets/assets/images/shame.png": "7dd56ba0e60831b6f8c555e7c3ff6526",
"assets/assets/svg/activity.svg": "f7281e449799bfb2eb170e4556aa46ba",
"assets/assets/svg/add_outline.svg": "180ff3ad82ce96471d872110834b0b38",
"assets/assets/svg/apple.svg": "72cc6addde09a34520bc4d1c156fc500",
"assets/assets/svg/bin.svg": "b68713ce324487ca52442d48802d9a3e",
"assets/assets/svg/chat_bubble.svg": "bb2b6ce240bba6c4d82b80be09372fe3",
"assets/assets/svg/chevron_left.svg": "4e8cd23977a4d3a5ce49498ebc51ff27",
"assets/assets/svg/delete_round.svg": "03bb350ce4150adc23e139e43aa0aaa3",
"assets/assets/svg/eye_hide.svg": "70fda05b1991b32b1711b44d004d2de6",
"assets/assets/svg/goal.svg": "f7281e449799bfb2eb170e4556aa46ba",
"assets/assets/svg/google.svg": "ae217a3682b83ee3940653729e96dc0d",
"assets/assets/svg/green_check.svg": "1a4d2fcf109c4cd6b09e18ac94c8be91",
"assets/assets/svg/home.svg": "acbade0ea28ce8022b16bca2aa7ed5ca",
"assets/assets/svg/mail_outline.svg": "2cf4a7dbc86566dd28c75e9fa2c5fb89",
"assets/assets/svg/pen.svg": "5fb809c430c3d6d5e90f43f4981e816d",
"assets/assets/svg/pulse.svg": "2ca39fde3caffc582592cfbb42d1b2ec",
"assets/assets/svg/resource_checked.svg": "cdf5a4f523f641afdd84021cff153d92",
"assets/assets/svg/settings.svg": "d1ab07a802691cc5864d7ccefb18b693",
"assets/assets/svg/settings_checked.svg": "e7282d99fff30e63b871fcaa48808f6e",
"assets/assets/svg/stack.svg": "65026f9f7714a3db4a6cdd4496e93672",
"assets/assets/svg/thumbs_up.svg": "f9ace73a8683288076c1738cf6c8c020",
"assets/assets/svg/timer.svg": "72e892a9f2da74993b3a15694b5124dc",
"assets/assets/svg/timer_late.svg": "f529947005a0ddb393d4c90537cc8659",
"assets/assets/svg/vector0.svg": "036d7e8c7c7884c33454345a5012517b",
"assets/assets/svg/vector1.svg": "acbade0ea28ce8022b16bca2aa7ed5ca",
"assets/assets/svg/vector2.svg": "bb2b6ce240bba6c4d82b80be09372fe3",
"assets/assets/svg/vector3.svg": "65026f9f7714a3db4a6cdd4496e93672",
"assets/assets/svg/vector4.svg": "d1ab07a802691cc5864d7ccefb18b693",
"assets/assets/svg/vector5.svg": "3db61c6b5313072c182dd464c1d535c8",
"assets/assets/svg/web/apple.svg": "4ce59b5cb2b69bb2eb275d014da8f6e4",
"assets/assets/svg/web/appointments.svg": "5f1f1254d8ebcee682f6acdba47ebd5a",
"assets/assets/svg/web/blog.svg": "9e2335c714ccb631aa2c73a2d1b1fb2d",
"assets/assets/svg/web/calendar.svg": "773c23aa49c8bc6b64c0b1b4132dfd24",
"assets/assets/svg/web/citizens.svg": "8288f6defee0df4c9825d2a3596f0587",
"assets/assets/svg/web/dashboard.svg": "19d080919fa3dda420bcc2fe488df53f",
"assets/assets/svg/web/delete.svg": "a3e2f9c076634fef015b620d84735295",
"assets/assets/svg/web/edit.svg": "b4104a4a8d1132afbb8924981f6ad607",
"assets/assets/svg/web/email.svg": "58d227917088719cd9fda38deeda2999",
"assets/assets/svg/web/logout.svg": "cb1f762fce324f297d174bf07ed5e7a1",
"assets/assets/svg/web/match.svg": "5affa585e1ad5becb868a2ac52098742",
"assets/assets/svg/web/notification.svg": "2c23be106e577f3a5387d7e19ec57c79",
"assets/assets/svg/web/parole.svg": "cbaa78e2bce832c578def91d3d27e673",
"assets/assets/svg/web/peer.svg": "3de7f7583bed71f690f1c9fca5116242",
"assets/assets/svg/web/search.svg": "174c20fe7042fb871de420c871fd1978",
"assets/assets/svg/web/settings.svg": "54b3963c6de0e2353ca317d50ee47038",
"assets/FontManifest.json": "459bc73eec28c40ea9067f47ec1648de",
"assets/fonts/MaterialIcons-Regular.otf": "55075648e04ead5a2d8a1914f639e175",
"assets/NOTICES": "871177ee1bf60dd87ae9a49a5fb5e843",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "2187d5980dda3992cc7913b50d7aceca",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "9dc76d3e739c5be5ea2423445a8ad785",
"/": "9dc76d3e739c5be5ea2423445a8ad785",
"main.dart.js": "26ce1f9dbcc981d482ac3175b8610480",
"manifest.json": "39a619e9220269f088d5ed7554c069a2",
"version.json": "d7b85ae858e0fbd53ced7d5e166da06d"};
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
