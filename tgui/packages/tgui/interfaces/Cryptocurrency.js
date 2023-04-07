import { Window } from '../layouts';
import { useBackend } from '../backend';
import { Box, Button, Chart, LabeledList, ProgressBar, Section, Stack } from '../components';

export const Cryptocurrency = () => {
  return (
    <Window title="Cryptocurrency Management" width={425} height={600}>
      <Window.Content scrollable>
        <CryptocurrencyDetails />
        <CryptocurrencyHistory />
        <CryptocurrencyMachineList />
      </Window.Content>
    </Window>
  );
};

export const CryptocurrencyDetails = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    authenticated,
    coin_name,
    exchange_rate,
    wallet,
    progress_required,
    total_mined,
    total_payout,
    market_closed,
  } = data;
  return (
    <Section title="Cryptocurrency Details"
      buttons={
        <Button
          icon="cash-register"
          content="Cash Out"
          disabled={!authenticated || wallet === 0}
          onClick={() => act('PRG_exchange')}
        />
      }>
        <Stack vertical>
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="Currency Name">
                {coin_name}
              </LabeledList.Item>
              <LabeledList.Item label="Exchange Rate">
                {exchange_rate}x
              </LabeledList.Item>
              <LabeledList.Item label="Wallet Balance">
                {wallet}
              </LabeledList.Item>
              <LabeledList.Item label="Work Units Required">
                {progress_required} Units
              </LabeledList.Item>
              <LabeledList.Item label="Total Earned Coin">
                {total_payout}
              </LabeledList.Item>
              <LabeledList.Item label="Total Mined Work">
                {total_mined} Units
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
          {market_closed ? (
            <Stack.Item fontSize="25px" textAlign="center" color="red">
              Market Closed!
            </Stack.Item>
          ) : ""}
        </Stack>
    </Section>
  );
};
export const CryptocurrencyHistory = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    exchange_rate_limit,
    mining_history,
    payout_history,
    exchange_rate_history,
  } = data;
  const mining_data = mining_history.map((value, i) => [i, value]);
  const payout_data = payout_history.map((value, i) => [i, value]);
  const exchange_rate_data = exchange_rate_history.map((value, i) => [i, value]);
  const mining_max = Math.max(...mining_history);
  const payout_max = Math.max(...payout_history);
  const exchange_rate_max = Math.max(exchange_rate_limit, ...exchange_rate_history);
  return (
    <Section title="Cryptocurrency History">
      <Box height="150px">
        <Chart.Line
          fillPositionedParent
          data={mining_data}
          rangeX={[0, mining_data.length - 1]}
          rangeY={[0, mining_max]}
          strokeColor="rgba(204, 60, 0, 1)"
          fillColor="rgba(204, 60, 0, 0.25)"
          height="150px"
        />
        <Chart.Line
          fillPositionedParent
          data={payout_data}
          rangeX={[0, payout_data.length - 1]}
          rangeY={[0, payout_max]}
          strokeColor="rgba(57, 224, 57, 1)"
          fillColor="rgba(57, 224, 57, 0.25)"
          height="150px"
        />
        <Chart.Line
          fillPositionedParent
          data={exchange_rate_data}
          rangeX={[0, exchange_rate_data.length - 1]}
          rangeY={[0, exchange_rate_max]}
          strokeColor="rgba(150,150,150,1)"
          height="150px"
        />
      </Box>
      <LabeledList>
        <LabeledList.Item textAlign="right">
          Updates once per minute
        </LabeledList.Item>
        <LabeledList.Item>
          <ProgressBar
            value={1}
            minValue={0}
            maxValue={1}
            color="rgba(204, 60, 0, 1)">
            Mining (max {mining_max})
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item>
          <ProgressBar
            value={1}
            minValue={0}
            maxValue={1}
            color="rgba(57, 224, 57, 1)">
            Payouts (max {payout_max})
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item>
          <ProgressBar
            value={1}
            minValue={0}
            maxValue={1}
            color="rgba(150,150,150,1)">
            Exchange Rate (max {exchange_rate_max})
          </ProgressBar>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

export const CryptocurrencyMachineList = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    machines,
  } = data;
  return (
    <Section title="Mining Rigs">
      {(!machines || machines.length === 0) ? 'None detected' :
      <LabeledList>
        {
          machines.map((rig) => (
            <CryptocurrencyMachineDetails key={rig.id_tag} rig={rig} />
          ))
        }
      </LabeledList>
      }
    </Section>
  );
};

export const CryptocurrencyMachineDetails = (props, context) => {
  const {
    rig,
  } = props;
  return (
    <LabeledList.Item label={rig.name}>
      {rig.progress} Units
    </LabeledList.Item>
  );
};
