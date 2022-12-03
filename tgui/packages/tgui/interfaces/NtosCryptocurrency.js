import { NtosWindow } from '../layouts';
import { CryptocurrencyDetails, CryptocurrencyHistory } from './Cryptocurrency';

export const NtosCryptocurrency = () => {
  return (
    <NtosWindow width={425} height={650}>
      <NtosWindow.Content scrollable>
        <CryptocurrencyDetails />
        <CryptocurrencyHistory />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
