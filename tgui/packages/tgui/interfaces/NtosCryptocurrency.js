import { useBackend } from '../backend';
import { Box, Chart, LabeledList, ProgressBar, Section } from '../components';
import { NtosWindow } from '../layouts';

export const NtosCryptocurrency = (props, context) => {
  const { data } = useBackend(context);
  const { coin_name, exchange_rate, total_mined, total_payout, event_chance, mining_history, payout_history } = data;
  const mining_data = mining_history.map((value, i) => [i, value]);
  const payout_data = payout_history.map((value, i) => [i, value]);
  return (
    <NtosWindow>
      <NtosWindow.Content scrollable>
        <Section title="Cryptocurrency Details">
          <LabeledList>
            <LabeledList.Item label="Currency Name">
              {coin_name}
            </LabeledList.Item>
            <LabeledList.Item label="Exchange Rate">
              {exchange_rate} : 1
            </LabeledList.Item>
            <LabeledList.Item label="Total Mined">
              {total_mined / 1000} kW
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
              rangeY={[0, Math.max(...mining_history)]}
              strokeColor="rgba(204, 60, 0, 1)"
              fillColor="rgba(204, 60, 0, 0.25)"
              height="150px"
            />
            <Chart.Line
              fillPositionedParent
              data={payout_data}
              rangeX={[0, payout_data.length - 1]}
              rangeY={[0, Math.max(...payout_history)]}
              strokeColor="rgba(57, 224, 57, 1)"
              fillColor="rgba(57, 224, 57, 0.25)"
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
                Mining
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item>
              <ProgressBar
                value={1}
                minValue={0}
                maxValue={1}
                color="rgba(57, 224, 57, 1)">
                Payout
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
