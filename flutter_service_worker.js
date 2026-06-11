'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"404.html": "86da08ddb03bd3d0728da7b2428c8223",
"assets/AssetManifest.bin": "829c1488bdc5696ab218f3dda28ca7c2",
"assets/AssetManifest.bin.json": "4f5f6c1bd519bf55cc99a3e7b113f333",
"assets/assets/chronology_img.png": "b1e18a53050ed3c7ced9a25597f14611",
"assets/assets/fonts/NotoSans-Bold.ttf": "28c191ce33ca36e0f75106491846de68",
"assets/assets/fonts/NotoSans-Italic.ttf": "a6d070775dd5e6bfff61870528c6248a",
"assets/assets/fonts/NotoSans-Regular.ttf": "f46b08cc90d994b34b647ae24c46d504",
"assets/assets/fonts/NotoSans-SemiBold.ttf": "f5a1e1476234ba356911d9b4e287e30d",
"assets/assets/history/agatangel.png": "8f7782f24fc0ce92e51d4bacf1a258ae",
"assets/assets/history/andriivska_church.png": "d61a4e835f6f9fa21958de107692ea4f",
"assets/assets/history/antonovych.png": "c73e89213576ce13a5b19da737c91fe1",
"assets/assets/history/arman_de_rishelie_monument.png": "6bd763f97cbe37a7a4de54e993047c35",
"assets/assets/history/ascension_of_christ.png": "3f9b9ffee487929480e966775430cc92",
"assets/assets/history/bahchysaray_zapovidnyk.png": "303b6b709b54446c4eef0edba643f59e",
"assets/assets/history/bandera.png": "4cdc620218dba525d55accfcea355e92",
"assets/assets/history/bilocur_bogdanivka_house.png": "a9a9c85abaee81af44193b6993d67d7a",
"assets/assets/history/black_stonehouse.png": "983ec03b690ae1c281a261966edcf233",
"assets/assets/history/bogorodytsa_prophets_icon.png": "242e547ffaf0f6e2e5004c32beb253f8",
"assets/assets/history/boims_chapel.png": "80d6aaac906a6a661713659137dd89d5",
"assets/assets/history/buchach_townhall.png": "52f9e820471f5f5ad89d56a6576ba9ca",
"assets/assets/history/chimeras_house.png": "a4b79f881a389055a770f8eed6cd89da",
"assets/assets/history/chornovil.png": "39e1d88d73c2b29d8a5aec69157ad497",
"assets/assets/history/chubynski.png": "9bd9b56a0999740c9648852447c095ce",
"assets/assets/history/circular_tower.png": "c5f9ebf294767f0bbcd989eced649298",
"assets/assets/history/defend_synagoga.png": "3078fbf9b9990fc7c18a2d591d210c2e",
"assets/assets/history/derzhprom_kharkiv.png": "3419d0661ce5fb60aadd095c666bfeb3",
"assets/assets/history/dnister.png": "b040e015c0c8c4125004dbfb37c602db",
"assets/assets/history/dontsov.png": "69f99321a524170f5edfde6dfcf2051e",
"assets/assets/history/dormition_icon.png": "860c6653bfe7732e7d84659454b58a65",
"assets/assets/history/dorogobuzka_bogorodytsa_icon.png": "1a725bba8ed1303b85ee6951890345f0",
"assets/assets/history/doroshenko.png": "2d696fad238860eab843af29f96c87ef",
"assets/assets/history/dovzhenko.png": "c1125b5281765ab4c1997148e6017632",
"assets/assets/history/dragomanov.png": "a949177f0f35c66113d603b5607f51a7",
"assets/assets/history/franko.png": "59470a496994a5253bb8825771d97094",
"assets/assets/history/gasprynsky.png": "467b0846d611cf2615d4ac95063e4e80",
"assets/assets/history/genues_fortress.png": "e1f4fd8794b4449a434bf91219ec6fed",
"assets/assets/history/georgiiv_church.png": "e9c37eccf579e21fa6d6ee89981f8077",
"assets/assets/history/gold_soloha_comb.png": "e728cc80a52c1e0b429ebf78b9f4a640",
"assets/assets/history/gonchar.png": "d0c3f68a82d6c3a6ec6c2ff1284499ef",
"assets/assets/history/grushevski.png": "cfa5d8eeddc2389736dd266679bd1bea",
"assets/assets/history/high_castle.png": "697644122b171bcbf2a52553108e9cb4",
"assets/assets/history/hmelnytski.png": "3db2f3752fc37266b08d8d8f50f7fd4b",
"assets/assets/history/hmelnytski_monument.png": "54b3e811265e00b7d4ec77f8d881b12e",
"assets/assets/history/hmelnytski_portrait.png": "b8346abc615672bec1a2a493818a4dba",
"assets/assets/history/holier_triad_chapel.png": "4a2f9a56adefb2099060b9fffa93d871",
"assets/assets/history/holms_bogorodytsa_icon.png": "dab34fbf344582631e9fd5aa0239e27c",
"assets/assets/history/hotynska_fortress.png": "85d77c15050a464e061bfe7cc37424ba",
"assets/assets/history/illinska_church.png": "d4fa247967d822a8fdec8d05affd5569",
"assets/assets/history/ivan_dzuba.png": "5ec0c8bd4298d6723a7b11b6260b4bd4",
"assets/assets/history/josyph_blind.png": "11c463f6591a023dff62ca9eb93de4d5",
"assets/assets/history/kamjanets_podilska_fortress.png": "26e0f87a26f7c6b443edef36e2611980",
"assets/assets/history/kasian_gucul_with_flower.png": "20e9feb004fdc3d1529d82aac6aef7a7",
"assets/assets/history/kasian_karpatska_maty.png": "80e21b90529390e05a47010724580f64",
"assets/assets/history/kateryna_shevchenko.png": "2860151d104d57537381031c87336818",
"assets/assets/history/khersones_tavr.png": "247b4b16a747687d1f3a55811e334a72",
"assets/assets/history/kiev_university.png": "b05f895ab4635e210af134ac00e2af84",
"assets/assets/history/konovalets.png": "1448f0c785f11af9b035aa9e537d5e87",
"assets/assets/history/kornjakts_house.png": "48f0a8632a767ef4606d4c364a97151b",
"assets/assets/history/kornjakts_tower_ansamble.png": "4eb1de8888b4b1a1cc7e3e8acb62d8a4",
"assets/assets/history/kravchuk.png": "2b534a132447dc15258da83f3feb9d4f",
"assets/assets/history/krychevski_tryptyh.png": "f189d0b4c7ed0debc94f02b84913c969",
"assets/assets/history/kuchma.png": "2766e6dceaa732582b6e878384acc231",
"assets/assets/history/kyrylos_palace_baturyn.png": "e4bb9becd737886d3a3c6ea583604490",
"assets/assets/history/lesja_ukrainka.png": "e1308cce9b848dd0e073560f680c3480",
"assets/assets/history/levytski.png": "75485c0122356d173caebd5290394d83",
"assets/assets/history/lubumyr_guzar.png": "8ca0bb44c97438ae16016fcca42797bf",
"assets/assets/history/luka_gravure_apostol.png": "6a5bbdc442bdd126ef1b259e75d5633c",
"assets/assets/history/lukjanenko.png": "fcd32389a5645e7666b88afa6647faa5",
"assets/assets/history/lysenko.png": "8e7a373cf9cf6e9a021c082da8eba899",
"assets/assets/history/mahno.png": "9e10c1487ffdb9f081bf064f391160f3",
"assets/assets/history/masepa&goodaffairs_gravure.png": "2906eb24054e1c8266d0e581f3157a00",
"assets/assets/history/masepa.png": "3acbcf963e415293aeae879ad9f768c8",
"assets/assets/history/meandr_bracelet.png": "0a71abe8443c6b2667d57f374ecb1732",
"assets/assets/history/mihnovski.png": "2e1336d252a5650d16469e4035a322c6",
"assets/assets/history/miniatures_peresop_evangelie.png": "a87283106ef7faed49f6b45b4c354c6b",
"assets/assets/history/miniature_ostrom_evangelie.png": "fd315ca76332216ae0fabe993eb32dc4",
"assets/assets/history/murashko_redhat_girl.png": "2233a5728691869f33f3bdf86459d291",
"assets/assets/history/mykhailo_goldenroof_cath.png": "09480751168adc3089e05acc6d8a1eab",
"assets/assets/history/mykolaichuk.png": "26b1f90fe3aa053ed0a3b85c331dcdb3",
"assets/assets/history/narbut_enei.png": "b1a07722522f230223ce1b6b86814e9f",
"assets/assets/history/odesa_opera_house.png": "43a776309cc9bac8804480b3f0ff8291",
"assets/assets/history/oforty_shevchenko.png": "01d6212c0e106df5bf5b0b29df419c80",
"assets/assets/history/orants&christ_mosaik.png": "d0d33e177097b60e9cea7db81e17854a",
"assets/assets/history/palanok_castle.png": "e0a56bcf60c9b72ab1ea1ba789cf8154",
"assets/assets/history/panteleymons_church.png": "64fb77d577e5be1eed0a542fb688c080",
"assets/assets/history/paradzhanov.png": "4776a00ea3b6043acf7195dd1a32dadd",
"assets/assets/history/pavlo_skoropadsy.png": "514aea8bf0fd499e02f18d301748f1b4",
"assets/assets/history/petro_grygorenko.png": "e857ea8489742e5e34f392b1b0c3feac",
"assets/assets/history/petro_mogyla.png": "8ceeb84d8c2db4852fa72bdff43e5de4",
"assets/assets/history/petrushevych.png": "97e2431a2709107b6885dbdd0a20e855",
"assets/assets/history/pidhirtsi_castle.png": "241c05fb54b164f4b3c7f0c3ea1f4f52",
"assets/assets/history/pokrovska_church.png": "8fb82a1a8a8f8ce69d4b861b21205b49",
"assets/assets/history/pokrovska_church_fortress.png": "51d5d7e78145fcd15bf3c5ddecc80f48",
"assets/assets/history/pokrov_bogorodytsi.png": "893cd2bb00208722e863b8ea3b959073",
"assets/assets/history/pokrov_cath.png": "f1b3c964cc90786f44679c85e63ee1af",
"assets/assets/history/poltava_gubern_house.png": "789e8ed8ee5070c26d9693b3a2e0961b",
"assets/assets/history/poroshenko.png": "e9736f0d61334f8197d3ecf62e3017d4",
"assets/assets/history/preobrazh_church.png": "32e8b9623b1619944058162fc29f50cb",
"assets/assets/history/pryimachenko_gorohovyi_zvir.png": "80f999f850445b38ae9ede15042b9996",
"assets/assets/history/pyatnytska_church.png": "cfb008e4fb2c42b0cfcd092b7a99777d",
"assets/assets/history/pymonenko_holy_vorozhinnja.png": "565f60b6ddcd1d69419200f0bd0916cc",
"assets/assets/history/repin_kossakswritealetter.png": "b6c6779af40a3e8313decdaf3275ee65",
"assets/assets/history/residence_orthodox_metropolitans.png": "5771093d1fa1a1f631d0d21327192904",
"assets/assets/history/rozumovski.png": "f633eb5dec3bb8897786b71715926b06",
"assets/assets/history/sagaidachnyi.png": "70bcd2fc807ce3d5b030bf2ead68b217",
"assets/assets/history/shashkevych.png": "9a344541912f6802ddaf4d32e1290cc1",
"assets/assets/history/shenchenko_autoportrait.png": "4c42dda10ef46511b858968302482f87",
"assets/assets/history/sheptytski.png": "4a40b52342585656e95356bde0e140d1",
"assets/assets/history/shevchenko_monument_romny.png": "2fb5a0571c9af82b7d72ed816daef9ad",
"assets/assets/history/shuhevych.png": "c49eb95656ce5c6fb27fa92233d245f0",
"assets/assets/history/skif_pectoral.png": "dad41c58f9f8eac0734c14489464bb5e",
"assets/assets/history/skovoroda.png": "62ff59c36fa55d0448f539a1aa82ce8f",
"assets/assets/history/solomija.png": "206a225e39eebcb135d0dff8303f1003",
"assets/assets/history/sophia_kiev_cath.png": "96acda72ef4eade204c94ffadfade530",
"assets/assets/history/spaso_preobr_cath.png": "bd762f1b789a57d2865c7b3ffe8bc387",
"assets/assets/history/stus.png": "8ce4f5448a620b27c95dc872e7de2d3b",
"assets/assets/history/st_yurii_cath.png": "d07d402910712dab979bef447e7b50fe",
"assets/assets/history/sven_icon_bogorodytsi.png": "542025049a93f38b6071509b55480d95",
"assets/assets/history/svjatoslavs_family.png": "d3155d9a1f2fbd85226cec02350511a7",
"assets/assets/history/symonenko.png": "683cc30f3a547ab9fb70cd719c13d3b7",
"assets/assets/history/symon_petlura.png": "a9ca358a1a45dcb28a2eca50cf4d3364",
"assets/assets/history/tarnovsky_house.png": "29ccb1c8b2cb877316b0ccfaf351ad01",
"assets/assets/history/tatjana_bread.png": "75e9694109f1b6dd0a4015bb1271522d",
"assets/assets/history/troitsky_cath.png": "c050fdaa71284f69884ebc0cd5eeff7f",
"assets/assets/history/troitsky_cath_novomoskovsk.png": "9f356f1bfdd9318d990702db42417334",
"assets/assets/history/tropinin_podillja_girl.png": "d75fe2c7de02efd48d576a8d6ea52833",
"assets/assets/history/trush_lesja_ukrainka.png": "cec3e3126c57d473ce5ce5951ff99a9f",
"assets/assets/history/tryp_ceramic.png": "c64e93a3a833b4140cc13ad92f6d8f31",
"assets/assets/history/usp_cath.png": "8849497e29c3d865db2092e98ee9fcd9",
"assets/assets/history/usp_cath_kievo-pecherskoi.png": "5666099e729c1d9704c653f1e5203681",
"assets/assets/history/usp_cath_pochaiv.png": "2dd958521a9482471b990d8fb8468070",
"assets/assets/history/usp_church_ansamble.png": "67254464fea18039e7dc2cb205cf6156",
"assets/assets/history/varfolomiys_costel.png": "a0276f10c93cf03b7f8a83277a84eb88",
"assets/assets/history/vasylkivski_kossaksinsteep.png": "a6152662a4a2af76ce460f5cc6ca2fcc",
"assets/assets/history/verbytski.png": "b446a3f007f8630a46a201d67a11bf73",
"assets/assets/history/vernadsky.png": "6c5f5560d6d0514805cb3202d69f2c21",
"assets/assets/history/virm_cath.png": "eb7e1077f54850d27f9657c3ba97add7",
"assets/assets/history/volodymyrsky_cath_kiev.png": "436c25ee3c7fa9f8336c230125ef63a8",
"assets/assets/history/volodymyr_velyky_monument.png": "130015fe7eb62a6a92f49cd0c207e719",
"assets/assets/history/voloshyn.png": "915caf376feda64799f24ff39c5d1d94",
"assets/assets/history/vynnychenko.png": "c172c69274447721feed3affa105ec47",
"assets/assets/history/vyshgorodska_icon.png": "3621ad62ceca4095f9a1df2d1a26adb8",
"assets/assets/history/v_k_ostroskyi.png": "f5f8b246e5547afeba1f84ef7945c3c3",
"assets/assets/history/yschenko.png": "c3eb3e263328d41993c6581e26502d93",
"assets/assets/history/yurii_snakehunter_drogobych.png": "fbee3d8429884ef05938e98a399609ee",
"assets/assets/history/yurii_snakehunter_sculpture.png": "81a5768e8ee7dc357ec4ef55d823bd28",
"assets/assets/history/zbrud_idol.png": "64bea8de880f8461cba9474f3dca7085",
"assets/assets/history/zishestja_church.png": "29513658ded720c2aea225bde5ce077e",
"assets/assets/history_data.json": "299d9562a75ea51700bd485abd949ae3",
"assets/assets/quotes_img.png": "c43db72ee12a54c7f3b8b8885a9aaeb2",
"assets/assets/terminology_img.png": "af1fb5191f0ad90db7d483a80eb38000",
"assets/assets/visual_img.png": "ba8c29902baaceb6bddc734c734b1902",
"assets/FontManifest.json": "c283f3609cf82f02a64c9baac800cf78",
"assets/fonts/MaterialIcons-Regular.otf": "db7705a253aec1c0f0fe6852d5171a5e",
"assets/NOTICES": "17249eb08a9c03442cbafb812ffb947d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "baad51b43c07c134657594366a155f4d",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "e0c4c6c53c57b322e977fe8764ca4511",
"/": "e0c4c6c53c57b322e977fe8764ca4511",
"launcher_icon.png": "14d75d9cbe4609c732551c3b79c75e7e",
"main.dart.js": "cad6654323d95ef6114fd2622a5757ee",
"manifest.json": "7a1bf8aa693d003bc61bb936361184ec",
"version.json": "071734d8a7b5a2174a750c6d3f1de4de"};
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
