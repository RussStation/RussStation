import { useBackend } from '../backend';
import { Box, Button, Chart, LabeledList, ProgressBar, Section } from '../components';
import { NtosWindow } from '../layouts';

export const NtosCryptocurrency = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    authenticated,
    coin_name,
    exchange_rate,
    wallet,
    progress_required,
    exchange_rate_limit,
    total_mined,
    total_payout,
    event_chance,
    mining_history,
    payout_history,
    exchange_rate_history,
  } = data;
  const mining_data = mining_history.map((value, i) => [i, value]);
  const payout_data = payout_history.map((value, i) => [i, value]);
  const exchange_rate_data = exchange_rate_history.map((value, i) => [i, value]);
  const mining_max = Math.max(progress_required, ...mining_history);
  const payout_max = Math.max(...payout_history);
  const exchange_rate_max = Math.max(exchange_rate_limit, ...exchange_rate_history);
  return (
    <NtosWindow>
      <NtosWindow.Content scrollable>
        <Section title="Cryptocurrency Details"
          buttons={
            <Button
              icon="cash-register"
              content="Cash Out"
              disabled={!authenticated}
              onClick={() => act('PRG_exchange')}
            />
          }>
          <LabeledList>
            <LabeledList.Item label="Currency Name">
              {coin_name}
            </LabeledList.Item>
            <LabeledList.Item label="Exchange Rate">
              {exchange_rate}
            </LabeledList.Item>
            <LabeledList.Item label="Wallet">
              {wallet}
            </LabeledList.Item>
            <LabeledList.Item label="Work Units Required">
              {progress_required}
            </LabeledList.Item>
            <LabeledList.Item label="Total Mined">
              {total_mined} Units
            </LabeledList.Item>
            <LabeledList.Item label="Total Payout">
              {total_payout} C
            </LabeledList.Item>
            <LabeledList.Item label="Market Volatility">
              {event_chance} %
            </LabeledList.Item>
          </LabeledList>
        </Section>
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
            <LabeledList.Item>
              <ProgressBar
                value={1}
                minValue={0}
                maxValue={1}
                color="rgba(204, 60, 0, 1)">
                Mining ({mining_max})
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item>
              <ProgressBar
                value={1}
                minValue={0}
                maxValue={1}
                color="rgba(57, 224, 57, 1)">
                Payouts ({payout_max})
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item>
              <ProgressBar
                value={1}
                minValue={0}
                maxValue={1}
                color="rgba(150,150,150,1)">
                Exchange Rate ({exchange_rate_max})
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
