// honk -- lobby music tgui component
import { Feature, FeatureNumberInput } from '../base';

export const lobby_music_volume: Feature<number> = {
  name: 'Lobby music volume',
  category: 'SOUND',
  description: 'The volume of lobby music tracks',
  component: FeatureNumberInput,
};
