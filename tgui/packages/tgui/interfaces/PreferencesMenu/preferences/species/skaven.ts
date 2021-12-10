import { createLanguagePerk, Species } from "./base";

const Skaven: Species = {
  description: "rats",
  features: {
    good: [createLanguagePerk("Queekish")],
    neutral: [],
    bad: [{
      icon: "wind",
      name: "Miasma Breathing",
      description: "Skaven must breathe miasma to survive. You receive a \
        tank when you arrive.",
    }],
  },
  lore: [
    "uh?",
  ],
};

export default Skaven;
