import { NtosWindow } from '../layouts';
import { CryptocurrencyDetails, CryptocurrencyHistory, CryptocurrencyMachineList } from './Cryptocurrency';

export const NtosCryptocurrency = () => {
  return (
    <NtosWindow width={425} height={650}>
      <NtosWindow.Content scrollable>
        <CryptocurrencyDetails />
        <CryptocurrencyHistory />
        <CryptocurrencyMachineList />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
