'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "8968500d61e62cab10ae7c275915b657",
"version.json": "f2fd7dd2484c9607996dcbfdd4f9b408",
"index.html": "ba261d46136ce9ded9694c00e52cb7a3",
"/": "ba261d46136ce9ded9694c00e52cb7a3",
"main.dart.js": "638ff2fb752cc22c5fa894d042cc56bb",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"manifest.json": "c441fadd790cf2d6c706f08c16832d14",
"icon_xizach.png": "7a731dbf865f681445413b7827137ce6",
"assets/AssetManifest.bin.json": "d89c5d0526e632b47b99bc5d6869019b",
"assets/NOTICES": "94d40390b4cbf9cfc230f69da73e087c",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/AssetManifest.bin": "b2a518fc8c03ddafcda6469a5c001e6d",
"assets/fonts/MaterialIcons-Regular.otf": "e9e103a2d69001f8a2add51dd2ad1394",
"assets/assets/svg/payment.svg": "b11e0ee1242303c6a602b59fd5f665b7",
"assets/assets/svg/home.svg": "8628a0df11fcfe7e4ae42e90fc61905f",
"assets/assets/svg/logout.svg": "b885e7dc92ed423f2c9a4d49bc040a4f",
"assets/assets/svg/point_search.svg": "aadc75ef2d7900fafbdc3e39a072b864",
"assets/assets/svg/ticket.svg": "a05f36ad7d6217a3b2892bdd4c463757",
"assets/assets/svg/locationPoint.svg": "5b35cb1bcdb9610775555ab71ba61b7c",
"assets/assets/svg/eyeClose.svg": "588c3c31d6dcc4136265dc415861827e",
"assets/assets/svg/lock.svg": "ceb1a0e2bbe6b6230ec78ccb97ad655b",
"assets/assets/svg/link.svg": "da07fecbfa8c039d76fc7ea7f185c025",
"assets/assets/svg/cart.svg": "bf836213f5f1c47517e3d40598e3b34c",
"assets/assets/svg/position.svg": "b86eb34689d5a97ea256e4f45430687e",
"assets/assets/svg/time.svg": "deee2aa054bb3212864a15fa1c66aea8",
"assets/assets/svg/wallet.svg": "e07dfb7c074c8d13dcde1b2636433755",
"assets/assets/svg/eyeOpen.svg": "9970b55ece8ad72be56df9016228ad3c",
"assets/assets/svg/payOut.svg": "8fffb787ed532cf6e572f1a39df39bab",
"assets/assets/svg/support.svg": "0cf407fa93f5176ee1eb447e0c88cd55",
"assets/assets/svg/add.svg": "4a0e5a2bcb8e2a1e3dbda4be1d1b6197",
"assets/assets/svg/close.svg": "009a84d8d10c456abc580dae3ba1bbda",
"assets/assets/svg/profi.svg": "836e296c1af6485c3bbea800fc9d3299",
"assets/assets/svg/setting.svg": "a9fc6dc8eef01d2cf7b220c8d0e46d7f",
"assets/assets/svg/back.svg": "c84e4522de79649e87dbad193ca98b71",
"assets/assets/svg/historyMoney.svg": "56602ff14b442cee8c523bc83a588e12",
"assets/assets/svg/truck.svg": "b88ec02fac341cb5a7f973187a78b803",
"assets/assets/svg/pointOnMap.svg": "0710611d32adab0dc39dd280debae4d4",
"assets/assets/svg/noti.svg": "04c917b0461613b566b7d2cdf6708372",
"assets/assets/svg/next.svg": "3da66b8821505b9fd7b21c86355d61c4",
"assets/assets/svg/voucher.svg": "e6e89bb3d9bc247c31ebe2fb05615702",
"assets/assets/svg/payIn.svg": "4a1a3608e6afb1352f9ab4c1062a1780",
"assets/assets/svg/three_dot.svg": "b5ce7889f67dce9498f6b44ee650080a",
"assets/assets/svg/gift.svg": "d3863a02bee1fb27c6406ed3d6b33bd3",
"assets/assets/svg/profile.svg": "4c8bbe7a24e05b79fd5228d16f8346d8",
"assets/assets/svg/filter.svg": "f076972ba8266c1907a246d433ee0589",
"assets/assets/svg/pay.svg": "74be49b96eda9e0a383adb283299c1ed",
"assets/assets/svg/menu.svg": "bc0cda784e19d4ff97504057918e4499",
"assets/assets/svg/threeDot.svg": "3a30d22d993e2bf61f42138db4db9c0c",
"assets/assets/images/hand.svg": "4274b6b521520de6649e68908c8936f3",
"assets/assets/images/icon.png": "a2a49eb3299ac8d2671107135d773ef9",
"assets/assets/images/group%25201.png": "4f655ae06c7aac2d368c07958503dc9b",
"assets/assets/images/plane.png": "98d44d90755302f7520adafbeb26aa7a",
"assets/assets/images/score-shape.png": "456d90cbcda159811386be5b8a646f0d",
"assets/assets/images/cloud%25201.png": "0a5b48c0e91f2e3fc960038086e47fae",
"assets/assets/images/Component_5.png": "e1c533535cb60fba1e52e8c3baefcda1",
"assets/assets/images/Component_4.png": "7c4a3a7450cdda89214fe7e7d2eb8531",
"assets/assets/images/NetBar.png": "78a6d661ddf2222650580dbfb1e9db5b",
"assets/assets/images/score-circles.svg": "7d33a4fd29131a0998949d61d60bb5be",
"assets/assets/images/Component_6.png": "013fb33e5f62d741709cafef88188a96",
"assets/assets/images/level.png": "c52aba33bd78a5da87ad3406c79b292d",
"assets/assets/images/logo.png": "c7a56e0dd73519ce52de8302960c7c62",
"assets/assets/images/stars.svg": "40cd076bbe77fe58ca94546dbccbd6bf",
"assets/assets/images/space-ship.svg": "671301e3dc5e3089defd6f21f36eecf3",
"assets/assets/images/logo_1.png": "822848942f6a3ddbad94366b132cee92",
"assets/assets/images/logo_3.png": "9ae4910588690fa323ef22cebf407f50",
"assets/assets/images/gem.png": "b6b1cf955d39a3ad33eb282ff5cf9e83",
"assets/assets/images/logo_2.png": "efa027b1200a5dc2641182dff3559b4e",
"assets/assets/images/wave.svg": "cda8aac2ec2a334529abd8ec338f278a",
"assets/assets/images/logo_4.png": "ea2f445ed653159ea1ec3482eb4c1d1c",
"assets/assets/t-images/8.png": "8f63f2d12263cc880387726b8e1df742",
"assets/assets/t-images/9.png": "8a724ca1d79a06d4675ce149003a0a0a",
"assets/assets/t-images/14.png": "df8b601ba4daeae7c14de4a289a159b5",
"assets/assets/t-images/15.png": "16ffe8da2ea3552c666a4f076974e205",
"assets/assets/t-images/17.png": "d281646f2ea0e3e9f4002a423b73ce67",
"assets/assets/t-images/16.png": "55b76f5800c38931eeb2b691fd6a4778",
"assets/assets/t-images/12.png": "1e56560dfc3638cc4e3cdb9b5d2513f9",
"assets/assets/t-images/13.png": "bf370a29da3b232b5a5d6fe707253a2b",
"assets/assets/t-images/11.png": "792dec4b92493b3516da5e4e69828366",
"assets/assets/t-images/10.png": "76654d706b1bba6b7ee427136a1e4f2a",
"assets/assets/t-images/21.png": "f4dcbbbac245dc11404b6e0c580d51cc",
"assets/assets/t-images/20.png": "2aa05d506d64dc3dbae43fa979da035d",
"assets/assets/t-images/22.png": "393a072dbd5c80fe9c5816bb66e3b0cf",
"assets/assets/t-images/23.png": "179b7dcf8896f5eec7029ee90e00ea40",
"assets/assets/t-images/18.png": "54df15693364855c6c3233a9313edfc4",
"assets/assets/t-images/24.png": "66d4a11230e4f523cb47cefd32926643",
"assets/assets/t-images/25.png": "a36da2c39751ac7e5c5a0f883c35b7b7",
"assets/assets/t-images/19.png": "5970b60c7c53f2a93e66e77ec37af8e9",
"assets/assets/t-images/4.png": "684d4e5131094bce26373ddbc3fb6cd2",
"assets/assets/t-images/5.png": "8f818bd2797adf28ac10cfb77c45b68b",
"assets/assets/t-images/7.png": "94f3310ea7edcaeecd49433ef28980c6",
"assets/assets/t-images/6.png": "5ef3d6e7aacbae6806d9a55fc2d544d5",
"assets/assets/t-images/2.png": "0010d43eccd827ce58360df3b4f52583",
"assets/assets/t-images/3.png": "c1e24e3dd3def6602e00733e5c78e824",
"assets/assets/t-images/1.png": "3505c9d5add704c82d228feda314044f",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01"};
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
