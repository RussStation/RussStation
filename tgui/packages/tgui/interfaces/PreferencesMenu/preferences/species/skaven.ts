// honk - skaven species screen

import { createLanguagePerk, Species } from "./base";

const Skaven: Species = {
  description: "The enigmatic Rat-folk, hailing from deep underground on many \
    planets. Having travelled amongst the stars through few feats of their \
    own, yet are industrious enough to have earned a spot among Nanotrasen's \
    less-than-finest.",
  features: {
    good: [createLanguagePerk("Queekish")],
    neutral: [],
    bad: [{
      icon: "wind",
      name: "Miasma Breathing",
      description: "Skaven must breathe miasma to survive. You receive a \
        tank when you arrive. Additional miasma can be created via compost \
        bins or ordered from cargo.",
    }, {
      icon: "hand-holding-usd",
      name: "Reduced Salary",
      description: "Skaven are not held in high regard. Your salary will be \
        significantly less than other species.",
    }],
  },
  lore: [
    "The Skaven have made homes and hovels underground on many planets, but poor recordkeeping and countless civil wars between numerous clans have lost their origin planet to time. What little records remain hint of a mysterious substance known as warpstone, but any accounts beyond being a source of great power have been chewed beyond recognition.",
    "Accustomed to depths far below most races would go, Skaven being among the surface dwellers are a relatively recent development. The clans united in an effort to seek the warpstone once more, so they might one day understand where they came from, and what drove their clans to such violence.",
  ],
};

export default Skaven;
