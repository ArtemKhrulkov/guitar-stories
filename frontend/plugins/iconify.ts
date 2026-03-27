import { addCollection } from "@iconify/vue";
import mdiIcons from "@iconify-json/mdi/icons.json";

export default defineNuxtPlugin(() => {
  addCollection(mdiIcons);
});
